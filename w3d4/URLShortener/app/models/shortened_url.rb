class ShortenedUrl < ActiveRecord::Base
  [ :long_url,
    :short_url ]. each { |field| attr_accessible field }

  validates :long_url, :presence => true
  validates :short_url, :presence => true
  validates :user_id, :presence => true

  belongs_to :submitter, :class_mame => "User", :foreign_key => "submitter_id"

  has_many :visits
  has_many :visitors, :class_name => "User", :through => :visits
end
