class Hero
  class << self; attr_accessor :score end
  @score = 0

  def self.update_score_with(points)
    @score += points.to_a.first
  end
end