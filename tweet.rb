require 'rubygems'
require 'bundler/setup'

require 'data_mapper'
require  'dm-migrations'

require 'twitter'
require 'pry'

DataMapper.setup(:default, "sqlite://"+Dir.pwd+"/data.db")

class Tweet
  include DataMapper::Resource

  property :id,         Serial
  property :tweet_id,   String
  property :user_name,  String
  property :user_id,    String
  property :created_at, DateTime
  property :body,       Text

  def self.retrieve!
    Twitter.search("@caffo").map do |t|
      unless Tweet.first(:tweet_id => t.id)
        Tweet.create(
            :tweet_id   => t.id,
            :user_id    => t["user"].id,
            :user_name  => t["user"].name,
            :body       => t.text
        ).save
      end
    end
  end

  def self.total_since(date_time)
   Tweet.count(:created_at.gt => date_time)
  end

end

DataMapper.finalize
#DataMapper.auto_migrate!

Tweet.retrieve! if ARGV[0] == 'run'