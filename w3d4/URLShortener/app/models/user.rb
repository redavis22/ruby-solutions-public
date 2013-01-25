class User < ActiveRecord::Base
  [ :name,
    :email ].each { |field| attr_accessible field }

  has_many :shortened_urls, :foreign_key => "submitter_id"
  has_many :visits

  validates :name, :presence => true
  validates :email, :uniqueness => true, :presence => true
end
