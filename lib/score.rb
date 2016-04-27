class Score

end

class SmallStraight < Score
  def initialize(dice: )
    @dice = dice
  end

  def find
    @dice.reduce(&:+) == Yatzy::SMALL_STRAIGHT_SCORE ? Yatzy::SMALL_STRAIGHT_SCORE : 0
  end

  def score
    find
  end
end