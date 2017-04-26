require 'dotenv'
Dotenv.load
require 'httparty'
require 'oauth'
require 'sinatra'

get '/' do
  @prediction = HTTParty.get('https://en.wikipedia.org/w/api.php?action=query&list=random&rnnamespace=0&format=json')['query']['random'][0]['title']
  erb :index
end

post '/twitter' do
  consumer = OAuth::Consumer.new(
    ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET'],
    { site: 'https://api.twitter.com', scheme: 'header' }
  )
  token_hash = { oauth_token: ENV['ACCESS_TOKEN'], oauth_token_secret: ENV['ACCESS_TOKEN_SECRET'] }
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
  access_token.request(:post, 'https://api.twitter.com/1.1/statuses/update.json', status: params[:button])
end
