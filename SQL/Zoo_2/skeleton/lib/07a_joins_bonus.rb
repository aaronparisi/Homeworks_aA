# == Schema Information
#
# Table name: albums
#
#  asin        :string       not null, primary key
#  title       :string
#  artist      :string
#  price       :float
#  rdate       :date
#  label       :string
#  rank        :integer
#
# Table name: styles
#
# album        :string       not null
# style        :string       not null
#
# Table name: tracks
# album        :string       not null
# disk         :integer      not null
# posn         :integer      not null
# song         :string

require_relative './sqlzoo.rb'

def alison_artist
  # Select the name of the artist who recorded the song 'Alison'.
  execute(<<-SQL)
    select A.artist
    from albums A
    join tracks T on A.asin = T.album
    where T.song = 'Alison';
  SQL
end

def exodus_artist
  # Select the name of the artist who recorded the song 'Exodus'.
  execute(<<-SQL)
    select A.artist
    from albums A
    join tracks T on A.asin = T.album
    where T.song = 'Exodus';
  SQL
end

def blur_songs
  # Select the `song` for each `track` on the album `Blur`.
  execute(<<-SQL)
    select T.song
    from albums A
    join tracks T on A.asin = T.album
    where A.title = 'Blur';
  SQL
end

def heart_tracks
  # For each album show the title and the total number of tracks containing
  # the word 'Heart' (albums with no such tracks need not be shown). Order first by
  # the number of such tracks, then by album title.
  execute(<<-SQL)
    select A.title, count(T.song)
    from albums A
    join tracks T on A.asin = T.album
    where song like '%Heart%'
    group by A.title
    having count(T.song) > 0
    order by count(T.song) desc, A.title;
  SQL
end

def title_tracks
  # A 'title track' has a `song` that is the same as its album's `title`. Select
  # the names of all the title tracks.
  execute(<<-SQL)
    select T.song
    from albums A
    join tracks T on A.asin = T.album
    where T.song = A.title;
  SQL
end

def eponymous_albums
  # An 'eponymous album' has a `title` that is the same as its recording
  # artist's name. Select the titles of all the eponymous albums.
  execute(<<-SQL)
    select title
    from albums
    where title = artist;
  SQL
end

def song_title_counts
  # Select the song names that appear on more than two albums. Also select the
  # COUNT of times they show up.
  # I want to count the number of times the song shows up
  # while also ensuring that I only count that for songs
  # which show up on multiple albums
  execute(<<-SQL)
    select t.song, count(t.song)
    from tracks t
    where t.song in 
      ( -- a list of all songs appearing on multiple albums
        select mults.song
        from 
          ( -- a list of songs and the number of albums on which they appear
            select t.song, count(distinct a.asin)
            from tracks t
            join albums a on t.album = a.asin
            group by t.song
            having count(distinct a.asin) > 2
          ) mults
      )
    group by t.song;
  SQL
end

def best_value
  # A "good value" album is one where the price per track is less than 50
  # pence. Find the good value albums - show the title, the price and the number
  # of tracks.
  execute(<<-SQL)
    select A.title, A.price, count(T.song)
    from albums A
    join tracks T on A.asin = T.album
    group by A.title, A.price
    having (A.price / count(T.song)) < .5
  SQL
end

def top_track_counts
  # Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101
  # tracks. List the top 10 albums. Select both the album title and the track
  # count, and order by both track count and title (descending).
  execute(<<-SQL)
    select A.title, count(T.song)
    from albums A
    join tracks T on A.asin = T.album
    group by A.title
    order by count(T.song) desc, A.title desc
    limit 10;
  SQL
end

def rock_superstars
  # Select the artist who has recorded the most rock albums, as well as the
  # number of albums. HINT: use LIKE '%Rock%' in your query.
  execute(<<-SQL)
    select A.artist, count(distinct A.title) as counts
      from albums A
      join styles S on A.asin = S.album
      where style like '%Rock%'
      group by A.artist
      order by counts desc
      limit 1;
  SQL
end

def expensive_tastes
  # Select the five styles of music with the highest average price per track,
  # along with the price per track. One or more of each aggregate functions,
  # subqueries, and joins will be required.
  #
  # HINT: Start by getting the number of tracks per album. You can do this in a
  # subquery. Next, JOIN the styles table to this result and use aggregates to
  # determine the average price per track.
  execute(<<-SQL)
    select S.style, (ppt_join.PPT/count(ppt_join.Album)) as avg_ppt
    from
      (select track_join.Album as Album, (A.price / track_join.Track_Count) as PPT
      from
        (select album as Album, count(song) as Track_Count
        from tracks
        group by album) track_join
      join albums A on track_join.album = A.asin
      where A.price is not null) ppt_join
    join styles S on ppt_join.Album = S.Album
    group by S.style, ppt_join.PPT
    order by avg_ppt desc, S.style
    limit 5;
  SQL
end
