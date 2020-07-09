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
    select M.title
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
    select M.title
    from movies M
    join castings C on M.id = C.movie_id
    join actors A on C.actor_id = A.id
    where A.name = 'Harrison Ford' and
      C.ord <> 1;
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
    select M.yr, count(*)
    from movies M
    join castings C on M.id = C.movie_id
    join actors A on C.actor_id = A.id
    where A.name = 'John Travolta'
    group by M.yr
    having count(*) > 1;
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
    select distinct MM.title, AA.name
    from movies MM
    join castings CC on MM.id = CC.movie_id
    join actors AA on CC.actor_id = AA.id
    where MM.title in
      (select title
      from movies M
      join castings C on M.id = C.movie_id
      join actors A on C.actor_id = A.id
      where A.name = 'Julie Andrews') and
      CC.ord = 1;
  SQL
end

# def andrews_films_and_leads
#   # List the film title and the leading actor for all of the films 'Julie
#   # Andrews' played in.
#   execute(<<-SQL)
#     select movies.title, lead_actors.name
#     from movies
#     join castings julie_castings on julie_castings.movie_id = movies.id
#     join actors julie_actors on julie_actors.id = julie_castings.actor_id
#     join castings lead_castings on lead_castings.movie_id = movies.id
#     join actors lead_actors on lead_actors.id = lead_castings.actor_id
#     where julie_actors.name = 'Julie Andrews' and lead_castings.ord = 1;
#   SQL
# end
# this solution says:
# "select titles and lead_actors' names from a table whose rows consist of
# 1. movie info
# 2. cast member info
# 3. cast member info AGAIN
# where the first instance of cast member info equals Julie Andrews
# and the second instance is the film's lead

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
    select A.name
    from castings C
    join actors A on C.actor_id = A.id
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
    select M.title as title, count(*) as cast_size
    from movies M
    join castings C on M.id = C.movie_id
    where M.yr = 1978
    group by M.title
    order by cast_size desc, title asc;
  SQL
end
# their solution says count(distinct C.actor_id)
# meaning if an actor is listed twice in the cast,
# they don't get counted twice??

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
    select name
    from movies MM
    join castings CC on MM.id = CC.movie_id
    join actors AA on CC.actor_id = AA.id
    where MM.id in
        (select M.id
        from movies M
        join castings C on M.id = C.movie_id
        join actors A on C.actor_id = A.id
        where A.name = 'Art Garfunkel')
      and AA.name <> 'Art Garfunkel';
  SQL
end
