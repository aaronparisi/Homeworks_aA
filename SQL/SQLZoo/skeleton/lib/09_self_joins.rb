# == Schema Information
#
# Table name: stops
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: routes
#
#  num         :string       not null, primary key
#  company     :string       not null, primary key
#  pos         :integer      not null, primary key
#  stop_id     :integer

require_relative './sqlzoo.rb'

def num_stops
  # How many stops are in the database?
  execute(<<-SQL)
    select count(id)
    from stops;
  SQL
end

def craiglockhart_id
  # Find the id value for the stop 'Craiglockhart'.
  execute(<<-SQL)
    select id
    from stops
    where name = 'Craiglockhart';
  SQL
end

def lrt_stops
  # Give the id and the name for the stops on the '4' 'LRT' service.
  execute(<<-SQL)
    select S.id, S.name
    from routes R
    join stops S on R.stop_id = S.id
    where R.num = '4' and R.company = 'LRT';
  SQL
end

def connecting_routes
  # Consider the following query:
  #
  # SELECT
  #   company,
  #   num,
  #   COUNT(*)
  # FROM
  #   routes
  # WHERE
  #   stop_id = 149 OR stop_id = 53
  # GROUP BY
  #   company, num
  #
  # The query gives the number of routes that visit either London Road
  # (149) or Craiglockhart (53). Run the query and notice the two services
  # that link these stops have a count of 2. Add a HAVING clause to restrict
  # the output to these two routes.
  execute(<<-SQL)
    select company, num, count(*)
    from routes
    where stop_id = 149 or stop_id = 53
    group by company, num
    having count(*) = 2;
  SQL
end

def cl_to_lr
  # Consider the query:
  #
  # SELECT
  #   a.company,
  #   a.num,
  #   a.stop_id,
  #   b.stop_id
  # FROM
  #   routes a
  # JOIN
  #   routes b ON (a.company = b.company AND a.num = b.num)
  # WHERE
  #   a.stop_id = 53
  #
  # Observe that b.stop_id gives all the places you can get to from
  # Craiglockhart, without changing routes. Change the query so that it
  # shows the services from Craiglockhart to London Road.
  execute(<<-SQL)
    select a.company, a.num, a.stop_id, b.stop_id
    from routes a
    join routes b on (a.company = b.company and a.num = b.num)
    where a.stop_id = 53 and b.stop_id = 149;
  SQL
end

def cl_to_lr_by_name
  # Consider the query:
  #
  # SELECT
  #   a.company,
  #   a.num,
  #   stopa.name,
  #   stopb.name
  # FROM
  #   routes a
  # JOIN
  #   routes b ON (a.company = b.company AND a.num = b.num)
  # JOIN
  #   stops stopa ON (a.stop_id = stopa.id)
  # JOIN
  #   stops stopb ON (b.stop_id = stopb.id)
  # WHERE
  #   stopa.name = 'Craiglockhart'
  #
  # The query shown is similar to the previous one, however by joining two
  # copies of the stops table we can refer to stops by name rather than by
  # number. Change the query so that the services between 'Craiglockhart' and
  # 'London Road' are shown.
  execute(<<-SQL)
    select a.company, a.num, stopa.name, stopb.name
    from routes a
    join routes b on (a.company = b.company and a.num = b.num)
    join stops stopa on (a.stop_id = stopa.id)
    join stops stopb on (b.stop_id = stopb.id)
    where stopa.name = 'Craiglockhart' and
      stopb.name = 'London Road';
  SQL
end

def haymarket_and_leith
  # Give the company and num of the services that connect stops
  # 115 and 137 ('Haymarket' and 'Leith')
  execute(<<-SQL)
    select distinct a.company, a.num
    from routes a
    join routes b on (a.company = b.company and a.num = b.num)
    join stops stopa on (a.stop_id = stopa.id)
    join stops stopb on (b.stop_id = stopb.id)
    where stopa.name = 'Haymarket' and
      stopb.name = 'Leith';
  SQL
end

def craiglockhart_and_tollcross
  # Give the company and num of the services that connect stops
  # 'Craiglockhart' and 'Tollcross'
  execute(<<-SQL)
    select distinct a.company, a.num
    from routes a
    join routes b on (a.company = b.company and a.num = b.num)
    join stops stopa on (a.stop_id = stopa.id)
    join stops stopb on (b.stop_id = stopb.id)
    where stopa.name = 'Craiglockhart' and
      stopb.name = 'Tollcross';
  SQL
end

def start_at_craiglockhart
  # Give a distinct list of the stops that can be reached from 'Craiglockhart'
  # by taking one bus, including 'Craiglockhart' itself. Include the stop name,
  # as well as the company and bus no. of the relevant service.
  execute(<<-SQL)
    select stopb.name, a.company, a.num
    from routes a
    join routes b on (a.company = b.company and a.num = b.num)
    join stops stopa on (a.stop_id = stopa.id)
    join stops stopb on (b.stop_id = stopb.id)
    where stopa.name = 'Craiglockhart';
  SQL
end

def craiglockhart_to_sighthill
  # Find the routes involving two buses that can go from Craiglockhart to
  # Sighthill. Show the bus no. and company for the first bus, the name of the
  # stop for the transfer, and the bus no. and company for the second bus.
  execute(<<-SQL)
    select distinct
      route1.num as start_num,
      route1.company as start_co,
      xfer_stop.name as xfer_at,
      route2.num as finish_num,
      route2.company as finish_co
    from routes route1
    join stops origin
      on route1.stop_id = origin.id
      -- 1st route and pickup info
    join routes xfer
      on xfer.company = route1.company and
        xfer.num = route1.num and
        xfer.stop_id <> origin.id
    join stops xfer_stop
      on xfer.stop_id = xfer_stop.id
      -- all destinations on route1
    join routes route2
      on route2.stop_id = xfer_stop.id and
        not (route2.company = route1.company and route2.num = route1.num)
      -- the bus that picks you up from the transfer
    join routes dest
      on dest.company = route2.company and
        dest.num = route2.num and
        dest.stop_id <> route2.stop_id
    join stops dest_stop
      on dest.stop_id = dest_stop.id
      -- destinations with the same co and num as route2
    where
      origin.name = 'Craiglockhart' and
      dest_stop.name = 'Sighthill';
  SQL
end

