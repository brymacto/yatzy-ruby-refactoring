class Yatzy

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
      "SmallStraight" => find_small_straight,
      "LargeStraight" => find_large_straight,
      "OnePair" => find_one_pair,
      "TwoPair" => find_two_pair,
      "FourOfAKind" => find_four_of_a_kind,
      "ThreeOfAKind" => find_three_of_a_kind,
      "Yatzy" => find_yatzy,
      "FullHouse" => find_full_house,
      "Singles" => find_singles,
      # "chance" => find_chance,
      # RMTODO (2016-04-26): bring chance back!  doesn't work right now because it's almost always the highest score.
      #  it only really works with multiple rolls which isn't implemented yet
    }
  end

  def find_chance
    @sum_of_dice
  end

  def find_small_straight
    @sum_of_dice == SMALL_STRAIGHT_SCORE ? SMALL_STRAIGHT_SCORE : 0
  end

  def find_large_straight
    @sum_of_dice == LARGE_STRAIGHT_SCORE ? LARGE_STRAIGHT_SCORE : 0
  end

  def find_singles
    dice_face_values_count = @dice_face_values_set
    score_singles(dice_face_values_count)
  end

  def score_singles(dice_face_values_count)
    dice_face_values_count.max_by { |k, v| k * v }.reduce(&:*)
  end

  def find_one_pair
    dice_face_values_count = @dice_face_values_set.select { |_k, v| v == 2 }
    score_one_pair(dice_face_values_count)
  end

  def score_one_pair(dice_face_values_count)
    return 0 if dice_face_values_count.empty?
    dice_face_values_count.max_by { |k, v| k * v }.reduce(&:*)
  end

  def find_two_pair
    dice_face_values_count = @dice_face_values_set.select { |_k, v| v == 2 }
    score_two_pair(dice_face_values_count)
  end

  def score_two_pair(dice_face_values_count)
    return 0 if dice_face_values_count.size != 2
    dice_face_values_count.map { |k, v| k * v }.reduce(&:+)
  end

  def find_three_of_a_kind
    dice_face_values_count = @dice_face_values_set.select { |_k, v| v == 3 }
    score_three_of_a_kind(dice_face_values_count)
  end

  def score_three_of_a_kind(dice_face_values_count)
    return 0 if dice_face_values_count.empty?
    dice_face_values_count.map { |k, v| k * v }.reduce(&:*)
  end

  def find_four_of_a_kind
    dice_face_values_count = @dice_face_values_set.select { |_k, v| v == 4 }
    score_four_of_a_kind(dice_face_values_count)
  end

  def score_four_of_a_kind(dice_face_values_count)
    return 0 if dice_face_values_count.empty?
    dice_face_values_count.max_by { |k, v| k }.reduce(&:*)
  end

  def find_yatzy
    @dice_face_values_set.size == 1 ? YATZY_SCORE : 0
  end

  def find_full_house
    dice_face_values_count = @dice_face_values_set
    three_of_a_kind = dice_face_values_count.key(3)
    pair = dice_face_values_count.key(2)

    three_of_a_kind && pair ? score_full_house : 0
  end

  def score_full_house
    @sum_of_dice
  end
end
