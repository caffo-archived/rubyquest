require 'rubygems'
require 'bundler/setup'

require 'sinatra'

require 'tweet'
require 'event'
require 'hero'


enable :sessions

get '/' do
  session[:rounds]    = 5 if session[:rounds].nil?
  session[:base_time] ||= Time.now

  if session[:rounds] == 0
    erb(Hero.score > 0 ? :win : :fail)
  else
    erb :index
  end
end

get '/door/:number' do
  influence   =  (Tweet.total_since(session[:base_time]) / 10 )
  probability = 50 + influence

  @shit_happened = rand(100) > probability

  if @shit_happened
    # poor hero
    @event = Event.choosen("bad")
  else
    # yay win
    @event = Event.choosen("good")
  end

  session['rounds'] = session['rounds']  -1 if session['rounds'] != 0
  Hero.update_score_with(@event["points"]) unless @event.nil?

  # resetting the base time to count
  # tweets posted from now on
  session[:base_time] = Time.now

  # display the right page
  @event.nil? ? redirect('/') : erb(:door)
end