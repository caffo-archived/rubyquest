require 'yaml'

class Event

  class << self; attr_accessor :good, :bad  end

  @good = YAML::load(File.open("events.yml"))["good"].sort_by { rand }
  @bad  = YAML::load(File.open("events.yml"))["bad"].sort_by { rand }

  def self.choosen(type="bad")
    oposite = type == "good" ? "bad" : "good"
    type, oposite = oposite, type if eval("Event.#{type}.empty?")
    eval("Event.#{type}.shift")
  end
end