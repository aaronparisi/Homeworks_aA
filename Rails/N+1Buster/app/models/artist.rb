class Artist < ApplicationRecord
  has_many :albums,
    class_name: 'Album',
    foreign_key: :artist_id,
    primary_key: :id

  def n_plus_one_tracks
    albums = self.albums
    tracks_count = {}
    albums.each do |album|
      tracks_count[album.title] = album.tracks.length
    end

    tracks_count
  end

  def better_tracks_query
    # TODO: your code here
    # count all tracks on each of an artist's albums
    # ! this pulls in all the track info, which we do not need
    # albums = self.albums.includes(:tracks)

    albums = self.albums
      .select("albums.*, count(*) as track_counts")
      .joins(:tracks)
      .group('albums.id')

    tracks_count = {}
    albums.each do |album|
      tracks_count[album.title] = album.tracks.length
    end

    return tracks_count
  end
end
