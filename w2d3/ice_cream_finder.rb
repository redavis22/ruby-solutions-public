require 'addressable/uri'
require 'json'
require 'nokogiri'
require 'rest-client'

GOOGLE_API_KEY = "SECRET_API_KEY"

def lat_lng(address)
  url = Addressable::URI.new(
    :scheme => "https",
    :host => "maps.googleapis.com",
    :path => "/maps/api/geocode/json",
    :query_values => {
      :address => address,
      :sensor => "false"
    }).to_s

  response = JSON.parse(RestClient.get(url))
  top_result = response["results"].first
  top_result["geometry"]["location"].values_at("lat", "lng")
end

def nearby_places(lat_lng, keyword)
  lat, lng = lat_lng
  url = Addressable::URI.new(
    :scheme => "https",
    :host => "maps.googleapis.com",
    :path => "/maps/api/place/nearbysearch/json",
    :query_values => {
      :key => GOOGLE_API_KEY,
      :location => "#{lat},#{lng}",
      :radius => 800,
      :sensor => "false",
      :keyword => keyword
    }).to_s

  response = JSON.parse(RestClient.get(url))

  response["results"].map do |result|
    result.select { |k, v| ["name", "vicinity"].include?(k) }
  end
end

def directions(from_address, to_address)
  url = Addressable::URI.new(
    :scheme => "https",
    :host => "maps.googleapis.com",
    :path => "/maps/api/directions/json",
    :query_values => {
      :origin => from_address,
      :destination => to_address,
      :sensor => "false",
      :mode => "walking",
    }).to_s

  response = JSON.parse(RestClient.get(url))
  route = response["routes"].first
  # legs only > 1 if waypoints specified
  leg = route["legs"].first

  distance = leg["distance"]["value"]

  steps = route["legs"].first["steps"]
  instructions = steps.map do |step|
    html = step["html_instructions"].gsub("Destination", ". Destination")
    Nokogiri::HTML(html).text + "."
  end

  { :distance => distance, :instructions => instructions }
end

def run
  puts "Current location:"
  current_location = gets.chomp
  current_lat_lng = lat_lng(current_location)

  puts "Place query:"
  query = gets.chomp
  places = nearby_places(current_lat_lng, query)

  puts "Options:"
  places.each_with_index { |place, index| puts "#{index}: #{place["name"]}" }

  puts "Selection:"
  selected_place = places[gets.chomp.to_i]
  directions = directions(current_location, selected_place["vicinity"])

  puts directions[:instructions]
  puts "Total distance: #{directions[:distance]}"

  nil
end
