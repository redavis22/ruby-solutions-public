class Visit < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :shortened_url_id, :presence => true

  belongs_to :visitor
  belongs_to :shortened_url
end
