require "sinatra"
require "forecast_io"
require "json"
require "httparty"

ForecastIO.api_key = "0b11f1a03028060fa9bddab0b4390855"
post "/" do
  json = JSON.parse(weather)
  today = json["daily"]["data"].first
  max = today["temperatureMax"].to_s

  text = "The high is " + max + " degrees in Carpenteria today!"

  if params[:channel_name].include?("support")
    text += " Bet you wish you were here!"
  end

  data = {
    channel: "#" + params[:channel_name],
    text: text
  }

  url = "https://hooks.slack.com/services/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"
  response = HTTParty.get(url, body: data.to_json)

  if response.success?
    response.body
  else
    raise BadRequest, response.body
  end
end

get "/data" do
  weather.to_s
end

def weather
  (ForecastIO.forecast 34.398,-119.518).to_json
end

class BadRequest < StandardError; end
