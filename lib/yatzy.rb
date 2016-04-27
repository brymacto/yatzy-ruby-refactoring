class Yatzy

  require "score"

  SMALL_STRAIGHT_SCORE = 15
  LARGE_STRAIGHT_SCORE = 20
  YATZY_SCORE = 50

  attr_reader :dice, :dice_face_values_set, :scores, :sum_of_dice

  def initialize(dice: roll)
    @dice = assign_dice(dice)
    @dice_face_values_set = build_dice_face_values_set
    @sum_of_dice = calculate_sum_of_dice
    @scores = calculate_scores
  end

  def self.roll
    dice = []
    5.times { dice << rand(1..6) }
    dice
  end

  def best_option
    @scores.max_by { |_k, v| v }
  end

  private

  def assign_dice(dice)
    raise "You need to use five dice" if dice.size != 5
    @dice = dice
  end

  def build_dice_face_values_set
    @dice.uniq.each_with_object({}) do |dice_face_value, memo|
      memo.store(dice_face_value, @dice.count(dice_face_value))
    end
  end

  def calculate_sum_of_dice
    @sum_of_dice = @dice.reduce(&:+)
  end

  def calculate_scores
    @scores = {
      "SmallStraight" => nil,
      "LargeStraight" => nil,
      "OnePair" => nil,
      "TwoPair" => nil,
      "FourOfAKind" => nil,
      "ThreeOfAKind" => nil,
      "YatzyScore" => nil,
      "FullHouse" => nil,
      "Singles" => nil,

      # "chance" => nil,
      # RMTODO (2016-04-26): bring chance back!  doesn't work right now because it's almost always the highest score.
      #  it only really works with multiple rolls which isn't implemented yet
    }

    @scores.each_key do |k|
      @scores[k] = klass_for(k).new(dice: @dice, dice_face_values_set: @dice_face_values_set).score
    end
  end

  def klass_for(klass)
    case klass
    when /SmallStraight/
        SmallStraight
      when /LargeStraight/
        LargeStraight
      when /OnePair/
        OnePair
      when /TwoPair/
        TwoPair
      when /FourOfAKind/
        FourOfAKind
      when /ThreeOfAKind/
        ThreeOfAKind
      when /YatzyScore/
        YatzyScore
      when /FullHouse/
        FullHouse
      when /Singles/
        Singles
      when /Chance/
        Chance
    end
  end
end
