# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
    select name
    from countries
    where gdp > 
      (select max(gdp)
      from countries
      where continent = 'Europe')
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
    select Sub.continent, C.name, Sub.max_area
    from 
      (select continent, max(area) as max_area
      from countries
      group by continent) Sub
    join countries C on Sub.max_area = C.area;
  SQL
end

# def large_neighbors
#   # Some countries have populations more than three times that of any of their
#   # neighbors (in the same continent). Give the countries and continents.
#   execute(<<-SQL)
#     select distinct c1.name, c1.continent
#     from countries c1
#     join countries c2
#       on
#         c1.continent = c2.continent and
#         c1.name <> c2.name
#     where c1.population > (c2.population * 3)
#   SQL
# end

# my old solution says:
# " select name and continent
# from countries
# where the population is larger than
# 3x the population of every OTHER country in the same continent"
# it aliases the countries table so it can match
# the continent being selected in the outer query
# with the continent being examined in the inner query

# my new solution says:
# "select distinct name and continent
# from a list consisting of every combination of 2 countries
# who are on the same continent
# where the population of the first country is larger than..."

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
    -- is there a way to do this that does not require
    -- 'keeping track' of the continent you're looking at???
end