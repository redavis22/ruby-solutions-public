class User < ActiveRecord::Base
  [ :name,
    :email ].each { |field| attr_accessible field }

  has_many :submitted_urls, :class_name => "ShortenedUrl", :foreign_key => "submitter_id"
  has_many :visits
  has_many :visited_urls, :class_name => "ShortenedUrl", :through => :visits, :source => :shortened_url

  validates :name, :presence => true
  validates :email, :uniqueness => true, :presence => true
end
