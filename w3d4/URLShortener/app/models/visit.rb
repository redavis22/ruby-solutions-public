class Visit < ActiveRecord::Base
  [ :user_id,
    :shortened_url_id ].each { |field| attr_accessible field }

  validates :user_id, :presence => true
  validates :shortened_url_id, :presence => true

  # I could have said `belongs_to :user` here, and everything would
  # have been inferred correctly, but I wanted the more semantically
  # meaningful "visitor". See discussion of overriding the defaults in
  # shortened_url.rb.
  belongs_to :visitor, :class_name => "User", :foreign_key => "user_id"
  belongs_to :shortened_url
end
