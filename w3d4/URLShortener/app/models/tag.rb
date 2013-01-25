class Tag < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true, :uniqueness => true

  has_many :taggings
  has_many :urls, :through => :taggings

  def most_popular_urls
    # this is the "real" way to do it
    urls
      .select("shortened_urls.*, COUNT(*) AS click_count")
      .joins(:visits)
      .group("shortened_urls.id")

    # this is the way you knew how to do on Thu
#    urls.sort_by { |url| url.visits.count }.take(5)

    # Bonus: the slight difference here is that the joins way will
    # drop urls with no visits (why?)
  end
end
