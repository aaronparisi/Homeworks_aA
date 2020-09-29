# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email)
#
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  has_many :shortened_urls

  has_many :visits
  has_many :visiteds, through: :visits, source: :visited
  
end

# when we say has_many :visiteds, we are saying
# "hey, when someone wants to do an active record thing like MyClass.visiteds
# they must call it visiteds"

# now usually, there would be a visiteds_id and a class visited

# but since we are channging the names, we have to be explicit about
# which fields in the related table to look at
# in this case, we want the shortened_url_id from the visits table
# but in this case, we didn't say 'a visit belongs to a user' we said it belongs
# to a visitor (and in that association we specified where that was to look)
# so we say source: :visited, i.e. the information which indicates which visited
# the visit belongs to, i.e. the user_id
