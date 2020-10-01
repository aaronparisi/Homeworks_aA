def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between
  # 3 and 5 (inclusive).
  # Show the id, title, year, and score.

  Movie.where('yr between ? and ?', 1980, 1989)
    .where('score between ? and ?', 3, 5)
    .select(:id, :score, :title, :yr)

end

def bad_years
  # List the years in which a movie with a rating above 8 was not released.

  goodYears = Movie.where('score >= 8').select(:yr)

  # Movie.where.not('yr in goodYears')
  #   .select(:yr)
  #   .uniq
  # I'm not sure how to turn the array of goodYears into a list

  Movie.group(:yr).having('MAX(score) < 8').pluck(:yr)
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.

  # Movie.where(title: title)
  #   .joins(:actors)
  #   .order('castings.ord')
  #   .select('actors.id, actors.name')
  # this WORKS, but notice that we are ultimately looking for ACTOR info

  Actor.joins(:movies)
    .where(movies: { title: title })
    .order('castings.ord')
    #.select(actors: { :id, :name })
    .select('actors.id, actors.name')
  # here we have to be specific about which table :title comes from
  # whereas above, we put the where clause right on movies prior to the join
end

def vanity_projects
  # List the title of all movies in which the director also appeared
  # as the starring actor.
  # Show the movie id and title and director's name.

  # Note: Directors appear in the 'actors' table.

  Movie.joins(:actors)
    .where('actors.id = movies.director_id')
    .where('castings.ord = 1')
    .select('movies.id, movies.title, actors.name')

end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name and number of supporting roles.

  Actor.joins(:castings)
    # .where('castings.ord <> 1')
    .where.not(castings: { ord: 1 })
    .group('actors.id')
    # .order('count(actors.id) desc')
    .order('roles DESC')
    .select('actors.id, actors.name, count(actors.id) as roles')
    .limit(2)
end
