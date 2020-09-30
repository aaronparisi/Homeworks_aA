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
#  id          :integer      not null, primary key
#  movie_id    :integer      not null
#  actor_id    :integer      not null
#  ord         :integer


def find_angelina
  #find Angelina Jolie by name in the actors table
  Actor.find_by(name: "Angelina Jolie")
end

def top_titles
  # get movie titles from movies with scores greater than or equal to 9
  # hint: use 'select' and 'where'
  Movie.where('score >= ?', 9).select(:id, :title)
end

def star_wars
  #display the id, title and year of each Star Wars movie in movies.
  # hint: use 'select' and 'where'
  Movie.where('title like ?', "%Star Wars%").select(:id, :title, :yr)
end


def below_average_years
  #display each year with movies scoring under 5,
  #with the count of movies scoring under 5 aliased as bad_movies,
  #in descending order
  # hint: use 'select', 'where', 'group', 'order'
  Movie.where('score < ?', 5)
    .select("movies.yr, COUNT(movies.title) as bad_movies")
    .group(:yr)
    .order('bad_movies')
  # 1. where is first (get all the movies with low scores)
  # 2. in select, we have to refer to the actual table name (i.e. movieS, plural)
  # 3. we cannot order by (:bad_movies) because bad_movies is not a column
  #    (thus not callable method on Movie),
  #    its an alias for some aggregation of info; we need 'bad_movies'
end

def alphabetized_actors
  # display the first 10 actor names ordered from A-Z
  # hint: use 'order' and 'limit'
  # Note: Ubuntu users may find that special characters
  # are alphabetized differently than the specs.
  # This spec might fail for Ubuntu users. It's ok!
  Actor.order(:name).limit(10)
end

def pulp_fiction_actors
  # practice using joins
  # display the id and name of all actors in the movie Pulp Fiction
  # hint: use 'select', 'joins', 'where'
  Actor.joins(:movies)
    .where('movies.title = ?', 'Pulp Fiction')
    .select(:id, :name)
end

def uma_movies
  #practice using joins
  # display the id, title, and year of movies Uma Thurman has acted in
  # order them by ascending year
  # hint: use 'select', 'joins', 'where', and 'order'
  Movie.joins(:actors)
    .where('actors.name = ?', 'Uma Thurman')
    .select(:id, :title, :yr)
    .order(:yr)
end
