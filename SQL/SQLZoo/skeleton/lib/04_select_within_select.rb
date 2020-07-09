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

# A note on subqueries: we can refer to values in the outer SELECT within the
# inner SELECT. We can name the tables so that we can tell the difference
# between the inner and outer versions.

def example_select_with_subquery
  execute(<<-SQL)
    SELECT
      name
    FROM
      countries
    WHERE
      population > (
        SELECT
          population
        FROM
          countries
        WHERE
          name='Romania'
        )
  SQL
end

def larger_than_russia
  # List each country name where the population is larger than 'Russia'.
  execute(<<-SQL)
    select name
    from countries
    where population > (
      select population
      from countries
      where name = 'Russia'
    )
  SQL
end

# their solution alises the tables, why?

def richer_than_england
  # Show the countries in Europe with a per capita GDP greater than
  # 'United Kingdom'.
  execute(<<-SQL)
    select name
    from countries
    where continent = 'Europe' and (gdp/population) > (
      select (gdp/population)
      from countries
      where name = 'United Kingdom'
    )
  SQL
end

def neighbors_of_certain_b_countries
  # List the name and continent of countries in the continents containing
  # 'Belize', 'Belgium'.
  execute(<<-SQL)
    select name, continent
    from countries
    where continent in (
      (select continent
      from countries
      where name = 'Belize')
      union
      (select continent
      from countries
      where name = 'Belgium')
    )
  SQL
end

# the UNION is a bit much, you can just say
# where name IN ('Belize', 'Belgium')

def population_constraint
  # Which country has a population that is more than Canada but less than
  # Poland? Show the name and the population.
  execute(<<-SQL)
    select name, population
    from countries
    where 
      population > (select population
                    from countries
                    where name = 'Canada') and 
      population < (select population
                    from countries
                    where name = 'Poland')
  SQL
end

def sparse_continents
  # Find every country that belongs to a continent where each country's
  # population is less than 25,000,000. Show name, continent and
  # population.
  # Hint: Sometimes rewording the problem can help you see the solution.
  # select countries in continents that have only tiny countries
  execute(<<-SQL)
    select name, continent, population
    from countries
    where continent in (
      select C.continent
      from countries C
      where 25000000 > all (
        select population
        from countries CC
        where C.continent = CC.continent
      )
    )
  SQL
end

# my solution says
# "give me name, continent, and population
# for every country whose continent is in a list
# of continents, all of whose countries are small"
# their solution takes advantage of the fact that
# a row in the countries table is disqualified
# if EVEN ONE country in a continent is too big
# so it says:
# "give me... from countries,
# where the continent is NOT IN a list of continents
# associated with a country whose population
# is large."
# their solution compares the current continent
# to a list which can have repeated continents
# if a single continent has multiple large countries
# but that doesn't really matter
# my solution looks through EVERY population
# for a given continent;
# theirs just looks at every continent containing
# at least one large country, and says,
# ok, if the continent of the current row is in there,
# we don't want it.