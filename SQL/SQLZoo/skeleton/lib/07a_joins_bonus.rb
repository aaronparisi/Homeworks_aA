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
    select song
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
    select A.title, count(*) as hart_count
    from albums A
    join tracks T on A.asin = T.album
    where T.song like '%Heart%'
    group by A.title
    having count(*) > 0
    order by count(*) desc, A.title;
  SQL
end

def title_tracks
  # A 'title track' has a `song` that is the same as its album's `title`. Select
  # the names of all the title tracks.
  execute(<<-SQL)
    select A.title
    from albums A
    join tracks T on A.asin = T.album
    where A.title = T.song;
  SQL
end

def eponymous_albums
  # An 'eponymous album' has a `title` that is the same as its recording
  # artist's name. Select the titles of all the eponymous albums.
  execute(<<-SQL)
    select distinct a1.title
    from albums a1
    join albums a2 on a1.title = a2.artist;
  SQL
end

def song_title_counts
  # Select the song names that appear on more than two albums. Also select the
  # COUNT of times they show up.
  execute(<<-SQL)
    select t.song, count(distinct a.title)
    from tracks t
    join albums a on t.album = a.asin
    group by t.song
    having count(distinct a.title) > 2;
  SQL
end

def best_value
  # A "good value" album is one where the price per track is less than 50
  # pence. Find the good value albums - show the title, the price and the number
  # of tracks.
  execute(<<-SQL)
    select A.title, A.price, count(T.*)
    from albums A
    join tracks T on A.asin = T.album
    group by A.title, A.price
    having A.price/count(T.*) < .50;
  SQL
end

# could also use mas(T.posn)
# except some albums have multiple sides / disks

def top_track_counts
  # Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101
  # tracks. List the top 10 albums. Select both the album title and the track
  # count, and order by both track count and title (descending).
  execute(<<-SQL)
    select a.title, count(t.*)
    from albums a
    join tracks t on a.asin = t.album
    group by a.title
    order by count(t.*) desc, title desc
    limit 10;
  SQL
end

def rock_superstars
  # Select the artist who has recorded the most rock albums, as well as the
  # number of albums. HINT: use LIKE '%Rock%' in your query.
  execute(<<-SQL)
    select a.artist, count(distinct a.*)
    from albums a
    join styles s on a.asin = s.album
    where s.style like '%Rock%'
    group by a.artist
    order by count(a.*) desc
    limit 1;
  SQL
end

# def expensive_tastes
#   # Select the five styles of music with the highest average price per track,
#   # along with the price per track. One or more of each aggregate functions,
#   # subqueries, and joins will be required.
#   #
#   # HINT: Start by getting the number of tracks per album. You can do this in a
#   # subquery. Next, JOIN the styles table to this result and use aggregates to
#   # determine the average price per track.
#   execute(<<-SQL)
#     select s.style, avg(l.price_per_track) as avg_price_per_track
#     from (
#       select k.asin as asin, k.price / k.track_count as price_per_track
#       from (
#         select t.asin as asin, count(t.*) as track_count, t.price as price
#         from (
#           select *
#           from albums a
#           join tracks t on a.asin = t.album
#         ) t -- all tracks with album info
#         group by t.asin, t.price
#         having t.price is not null
#       ) k -- album codes, track counts, and prices
#     ) l -- album codes and price per track
#     -- the style and average price per track
#     join styles s on l.asin = s.album
#     -- where styles are matched to albums by the album code
#     group by s.style
#     order by avg_price_per_track desc, s.style
#     limit 5;
#   SQL
# end

def expensive_tastes
  # Select the five styles of music with the highest average price per track,
  # along with the price per track. One or more of each aggregate functions,
  # subqueries, and joins will be required.
  #
  # HINT: Start by getting the number of tracks per album. You can do this in a
  # subquery. Next, JOIN the styles table to this result and use aggregates to
  # determine the average price per track.
  execute(<<-SQL)
    select S.style as style, sum(C.Price) / sum(C.track_count) as avg_price_per_track
    from
      (select A.asin as asin, count(T.*) as track_count, A.price as Price
      from albums A
      join tracks T on T.album = A.asin
      where A.Price is not null
      group by A.asin) C  -- C has tracks per album and album price
    join styles S on C.asin = S.album
    group by S.style
    order by avg_price_per_track desc, style
    limit 5;
  SQL
end