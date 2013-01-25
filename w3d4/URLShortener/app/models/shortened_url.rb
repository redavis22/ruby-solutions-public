class ShortenedUrl < ActiveRecord::Base
  [ :long_url,
    :short_url,
    :submitter_id ]. each { |field| attr_accessible field }

  validates :long_url, :presence => true
  validates :short_url, :presence => true
  validates :submitter_id, :presence => true

  belongs_to :submitter, :class_name => "User", :foreign_key => "submitter_id"

  has_many :visits
  has_many :visitors, :through => :visits
end
