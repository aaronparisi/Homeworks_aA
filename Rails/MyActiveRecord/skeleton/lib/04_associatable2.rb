require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options
  # I think this will just add additional functionality to the module
  # defined in 03

  def has_one_through(name, through_name, source_name)
    # given the name of the association,
    # the name of the SQLObject class through which the association flows,
    # and the name of the model we will query,
    # calling has_one_through will give the calling class a method, :name,
    # which will return the associated object from source

    # we need the options linking us from THIS class to the THROUGH class
    # remember, each belongs_to association saves an entry in the @assoc_options
    # with key=name_of_association
    through_options = assoc_options[through_name]
    source_options = through_options.model_class.assoc_options[source_name]
=begin
select houses.*                 <- source_options class_name  
from humans                     <- through_options class_name
join houses                     <- source_options class_name
on humans.house_id = houses.id  <- source_options foreign_key, source_options primary_key
where humans.id = ?             <- through_options primary_key, foreign_key
=end
    define_method(name.to_s) do
      query = DBConnection.execute(<<-SQL, self.send(through_options.foreign_key))
        select
          #{source_options.table_name}.*
        from
          #{through_options.table_name}
        join
          #{source_options.table_name}
        on
          #{through_options.table_name}
            .#{source_options.foreign_key} = #{source_options.table_name}
                                                .#{source_options.primary_key}
        where
          #{through_options.table_name}.
            #{through_options.primary_key} = ?
      SQL

      return source_options.model_class.parse_all(query).first
    end
  end
end

=begin
eg. a Cat has one HOME through HUMAN, source name HOUSE
remember, the module Associatable has a CLASS INSTANCE VARIABLE, @assoc_options
which is accessible here

say we have cat belongs to human, human belongs to home
then we are going to have TWO belongs to relationships

ok so we are going to have 3 instances of the sql object class
1. cat
2. human
3. house

cat belogns_to human
therefore the CAT class has a CLASS INSTANCE VARIABLE @assoc_options:
{ owner: aBelongsToOptionsInstance{ foreign_key: owner_id, class_name: Human, primary_key: id} }

human belongs_to house
therefore the HUMAN class has its own CLASS INSTANCE VARIABLE @assoc_options:
{ home: aBelongsToOptionsInstance{ foreign_key: home_id, class_name: House, primary_key: id} }

any class calling has_one_through will have access to its OWN @assoc_options

=end