require 'json'
require 'launchy'
require 'oauth'
require 'yaml'

CONSUMER_KEY = "consumer_key_from_service"
CONSUMER_SECRET = "consumer_secret_from_service"

CONSUMER = OAuth::Consumer.new(
  CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

class Tweet
  attr_reader :created_at, :text, :name

  def initialize(hash)
    @created_at, @text = hash["created_at"], hash["text"]
    @name = hash["user"]["name"]
  end

  def to_s
    "#{name}: #{text} ((#{created_at}))"
  end
end

class TwitterSession
  def initialize(token_file)
    @token = get_token(token_file)
  end

  def twitter_url(path, query_values = nil)
    Addressable::URI.new(
      :scheme => "https",
      :host => "api.twitter.com",
      :path => path,
      :query_values => query_values
      ).to_s
  end

  def home_timeline
    url = twitter_url("/1.1/statuses/home_timeline.json")
    JSON.parse(@token.get(url).body).map { |tweet_hash| Tweet.new(tweet_hash) }
  end

  def user_timeline(screen_name)
    url = twitter_url(
      "/1.1/statuses/user_timeline.json",
      { :screen_name => screen_name })
    JSON.parse(@token.get(url).body).map { |tweet_hash| Tweet.new(tweet_hash) }
  end

  def post_status(status)
    url = twitter_url("/1.1/statuses/update.json")
    @token.post(url, { :status => status })
  end

  def direct_messages
    url = twitter_url("1.1/direct_messages.json")
    JSON.parse(@token.get(url).body)
  end

  def direct_message(screen_name, text)
    url = twitter_url("1.1/direct_messages/new.json")
    @token.post(url, { :screen_name => screen_name, :text => text })
  end

  private
  def get_token(token_file)
    if File.exist?(token_file)
      File.open(token_file) { |f| YAML.load(f) }
    else
      access_token = request_access_token
      File.open(token_file, "w") { |f| YAML.dump(access_token, f) }

      access_token
    end
  end

  def request_access_token
    request_token = CONSUMER.get_request_token

    authorize_url = request_token.authorize_url
    puts "Go to this URL: #{authorize_url}"
    Launchy.open(authorize_url)

    puts "Login, and type your verification code in"
    oauth_verifier = gets.chomp

    request_token.get_access_token(:oauth_verifier => oauth_verifier)
  end
end
