def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.

  # Movie.joins(:actors)
  # .where(actors: { name: those_actors })
  # .where(castings: { ord: 1 })
  #   .select('movies.title, movies.id')
  # this shows "movies whose starring actor is one of the names in the list"
  # I think they want "movies where EACH actor in the list is in the cast"

  Movie.select(:title, :id)
    .joins(:actors)
    .where(actors: { name: those_actors })
    .group(:id)
    .having('count(movies.id) >= ?', those_actors.length)

end

def golden_age
  # Find the decade with the highest average movie score.

  # Movie.select('avg(score) as avg_score')
  #   .group(:yr)
  #   .having('yr like ?', )
  #   .order('AVG(movies.score)')
  #   .limit(1)

  Movie.select('(yr / 10) * 10 as decade') # integer division rounds
    .group('decade') # decade is a SQL thing, not an active record thing
    .order('avg(score) desc')
    # .limit(1) # this returns an ActiveRecordRelation
    .first
    .decade

    # lessons:
    # 1. we have to CONSTRUCT decades, and we can refer to it as a SQL thing
    # 2. limit returns an active record object, first returns an ARRAY
    # if we leave out .first, we get all the decades
    # if we leave off .decade, we get a MOVIE (NOT an ActiveRecord object)

    # limit:
    # expected #<Integer:3841> => 1920
    # got #<Movie::ActiveRecord_Relation:12940> => #<ActiveRecord::Relation [#<Movie id: nil>]>
end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery

  theirMovies = Movie.select(:title).joins(:actors).where(actors: { name: name })

  Actor
    .joins(:movies)
    .where(movies: { title: theirMovies })
    .where.not(actors: { name: name })
    .uniq
    .pluck(:name)

end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie

  # withCastings = Actor.joins(:castings).uniq.pluck(:name)

  # Actor.where.not(name: withCastings).length
  # ^^ this makes TWO queries, no bueno

  Actor.joins("LEFT JOIN castings on actors.id = castings.actor_id")
    .where('castings.id is null')
    .count
  # we have to be specific about which kind of join we want to do
  # the default join is INNER JOIN

end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"

  # ins = whazzername.split(' ').join('').split('').join('%')
  # this WORKS but it's not ideal
  ins = "%#{whazzername.split(//).join('%')}%"

  Movie.joins(:actors)
    .where('lower(actors.name) like ?', ins)

end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.

  Actor.joins(:movies)
    .select(:id, :name, ('(max(movies.yr)-min(movies.yr)) as career'))
    .group('actors.id, actors.name')  # unnecessary; we are not aggregating career
    .order('career desc')
    .limit(3)


end
