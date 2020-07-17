# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
    select distinct M.title
    from movies M
    join castings C on M.id = C.movie_id
    join actors A on C.actor_id = A.id
    where A.name = 'Harrison Ford';
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
    select distinct M.title
    from movies M
    join castings C on M.id = C.movie_id
    join actors A on C.actor_id = A.id
    where A.name = 'Harrison Ford' and C.ord <> 1;
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
    select M.title, A.name
    from movies M
    join castings C on M.id = C.movie_id
    join actors A on C.actor_id = A.id
    where M.yr = 1962 and C.ord = 1;
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
    select M.yr, count(M.title)
    from movies M
    join castings C on M.id = C.movie_id
    join actors A on C.actor_id = A.id
    where A.name = 'John Travolta'
    group by M.yr
    having count(M.title) > 1;
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
    select M.title, A.name
    from movies M
    join castings C on M.id = C.movie_id
    join actors A on C.actor_id = A.id
    where C.ord = 1 and M.title in (
      select distinct MM.title
      from movies MM
      join castings CC on MM.id = CC.movie_id
      join actors AA on CC.actor_id = AA.id
      where AA.name = 'Julie Andrews'
    );
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
    select A.name
    from actors A
    join castings C on A.id = C.actor_id
    where C.ord = 1
    group by A.name
    having count(A.name) >= 15
    order by A.name;
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
    select M.title as Title, count(C.actor_id) as CastSize
    from movies M
    join castings C on M.id = C.movie_id
    where M.yr = 1978
    group by M.title
    order by CastSize desc, Title;
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
    select A.name
    from movies M
    join castings C on M.id = C.movie_id
    join actors A on C.actor_id = A.id
    where A.name <> 'Art Garfunkel' and title in (
      select MM.title
      from movies MM
      join castings CC on MM.id = CC.movie_id
      join actors AA on CC.actor_id = AA.id
      where AA.name = 'Art Garfunkel'
    );
  SQL
end
