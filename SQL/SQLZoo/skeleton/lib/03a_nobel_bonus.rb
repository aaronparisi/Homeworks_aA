# == Schema Information
#
# Table name: nobels
#
#  yr          :integer
#  subject     :string
#  winner      :string

require_relative './sqlzoo.rb'

def physics_no_chemistry
  # In which years was the Physics prize awarded, but no Chemistry prize?
  execute(<<-SQL)
    select distinct P.yr
    from (
      select yr
      from nobels
      where subject = 'Physics') P
    left join (
      select yr
      from nobels
      where subject = 'Chemistry') C on P.yr = C.yr
      where C.yr is null
  SQL
end

# my solution:
# "select all distinct instances of P.yr
# from a table consisting of
# all years that have a Physics prize
# LEFT JOINED with all years that have a Chem prize
# (i.e. both or just Physics),
# excluding anything where C.yr is not null"

# their solution:
# "select distinct years
# from the nobel table
# where subject = physics, AND
# the year is NOT IN a query consisting of
# all the years where the subject = Chemistry"