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
    select c1.name
    from countries c1
    where c1.gdp > ALL (
      select c2.gdp
      from countries c2
      where c2.continent = 'Europe' and c2.gdp is not null
    );
  SQL
end

# my solution: "make sure c1's GDP is greater than ALL European GDP's"
# their solution: "make sure it's bigger than Europe's biggest"
# I think their solution gets rid of the null issue 

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
    select c1.continent, c1.name, c1.area
    from countries c1
    where c1.area > ALL (
      select c2.area
      from countries c2
      where c1.continent = c2.continent and c1.name <> c2.name
    )
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
    select c1.name, c1.continent
    from countries c1
    where c1.population > ALL (
      select c2.population * 3
      from countries c2
      where c1.continent = c2.continent and c1.name <> c2.name
    );
  SQL
end
