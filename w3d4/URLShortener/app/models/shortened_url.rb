class ShortenedUrl < ActiveRecord::Base
  # this says to make each of these fields attr_accessible;
  # `attr_accessible` is just a class method, and I can call it like
  # normal inside a block passed to an `each`.
  #
  # I like to do this because the list of attr_accessible attributes
  # is often very long; I think it reads better as an array.
  [ :long_url,
    :short_url,
    :submitter_id ]. each { |field| attr_accessible field }

  validates :long_url, :presence => true
  validates :short_url, :presence => true
  validates :submitter_id, :presence => true

  # My `shortened_urls` table has a column `submitter_id` which is a
  # foreign key into the `users` table. Because this doesn't follow
  # the rails convention, I need to specify the foreign key
  # column. The related table and the type of objects it contains is
  # inferred from `:class_name => "User"`.
  #
  # `submitter` is just the name of the association; because I specified
  # `class_name` and `foreign_key`, there's nothing left for Rails to
  # infer from `sumitter`, so I could have chosen any name for this.
  belongs_to :submitter, :class_name => "User", :foreign_key => "submitter_id"

  has_many :visits
  # Note that `visits` is the name of the association *through which*
  # we can find the visitors. For each `Visit`, Rails will look up the
  # associated `visitor`.
  has_many :visitors, :through => :visits
end
