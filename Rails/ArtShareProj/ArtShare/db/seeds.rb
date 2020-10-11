# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(username: "Andrew")
User.create(username: "Aaron")
User.create(username: "Christopher")
User.create(username: "Sarah")

Artwork.create(title: "Andrew's First", image_url: "www.google.com", artist_id: 1)
Artwork.create(title: "Aaron's First", image_url: "www.google.com", artist_id: 2)
Artwork.create(title: "Christopher's First", image_url: "www.google.com", artist_id: 3)
Artwork.create(title: "Sarah's First", image_url: "www.google.com", artist_id: 4)

ArtworkShare.create(viewer_id: 1, artwork_id: 2)
ArtworkShare.create(viewer_id: 2, artwork_id: 3)
ArtworkShare.create(viewer_id: 3, artwork_id: 4)
ArtworkShare.create(viewer_id: 4, artwork_id: 1)

Comment.create(body: "amazing", author_id: 1, artwork_id: 2)
Comment.create(body: "amazing", author_id: 2, artwork_id: 3)
Comment.create(body: "amazing", author_id: 3, artwork_id: 4)
Comment.create(body: "amazing", author_id: 4, artwork_id: 1)

Like.create(likeable_type: "Artwork", likeable_id: 1, user_id: 1)
Like.create(likeable_type: "Artwork", likeable_id: 2, user_id: 2)
Like.create(likeable_type: "Artwork", likeable_id: 3, user_id: 3)
Like.create(likeable_type: "Artwork", likeable_id: 4, user_id: 4)

Collection.create(name: "Andrew's Collection", artist_id: 1)
CollectionAssignment.create(collection_id: 1, artwork_id: 2)
CollectionAssignment.create(collection_id: 1, artwork_id: 3)
CollectionAssignment.create(collection_id: 1, artwork_id: 4)