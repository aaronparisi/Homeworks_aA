# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u1 = User.create(email: "parisi.aaron@gmail.com")
u2 = User.create(email: "aaronparisi@yahoo.com")
u3 = User.create(email: "aarons_coding_stuff@gmail.com")
u4 = User.create(email: "parisia2@hartwick.edu")
u5 = User.create(email: "aparisi@1031services.com")

ShortenedUrl.create_short_url(u1, "www.google.com")
ShortenedUrl.create_short_url(u2, "www.yahoo.com")
ShortenedUrl.create_short_url(u3, "www.github.com")
ShortenedUrl.create_short_url(u4, "www.hartwick.edu")
ShortenedUrl.create_short_url(u5, "www.1031services.com")