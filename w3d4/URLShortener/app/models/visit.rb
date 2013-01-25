class Visit < ActiveRecord::Base
  [ :user_id,
    :shortened_url_id ].each { |field| attr_accessible field }

  validates :user_id, :presence => true
  validates :shortened_url_id, :presence => true

  belongs_to :visitor, :class_name => "User", :foreign_key => "user_id"
  belongs_to :shortened_url
end
