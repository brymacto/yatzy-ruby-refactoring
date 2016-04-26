class Yatzy

  SMALL_STRAIGHT_SCORE = 15
  LARGE_STRAIGHT_SCORE = 20
  YATZY_SCORE = 50

  def self.roll
    dice = []
    5.times { dice << rand(1..6) }
    dice
  end

  def self.chance( dice: )
    dice.reduce(&:+)
  end

  def self.small_straight( dice: )
    dice.reduce(&:+) == SMALL_STRAIGHT_SCORE ? SMALL_STRAIGHT_SCORE : 0
  end

  def self.large_straight( dice: )
    dice.reduce(&:+) == LARGE_STRAIGHT_SCORE ? LARGE_STRAIGHT_SCORE : 0
  end

  def self.singles( number: , dice: )
    raise "you can only use 6-sided dice (number must be between 1 and 6)" if (number < 1) || (number > 6)

    dice_face_values_count = build_dice_face_values_set(dice).select { |k, _v| k == number }
    score_singles(dice_face_values_count)
  end

  def self.score_singles(dice_face_values_count)
    return 0 if dice_face_values_count.empty?
    dice_face_values_count.flatten.reduce(&:*)
  end

  def self.one_pair( dice: )
    dice_face_values_count = build_dice_face_values_set(dice).select { |_k, v| v == 2 }
    score_one_pair(dice_face_values_count)
  end

  def self.score_one_pair(dice_face_values_count)
    dice_face_values_count.max_by { |k, v| k }.reduce(&:*)
  end

  def self.two_pair( dice: )
    dice_face_values_count = build_dice_face_values_set(dice).select { |_k, v| v == 2 }
    score_two_pair(dice_face_values_count)
  end

  def self.score_two_pair(dice_face_values_count)
    return 0 if dice_face_values_count.size < 2
    dice_face_values_count.map { |k, v| k * v }.reduce(&:+)
  end

  def self.three_of_a_kind( dice: )
    dice_face_values_count = build_dice_face_values_set(dice).select { |_k, v| v == 3 }
    score_three_of_a_kind(dice_face_values_count)
  end

  def self.score_three_of_a_kind(dice_face_values_count)
    dice_face_values_count.map { |k, v| k * v }.reduce(&:*)
  end

  def self.four_of_a_kind( dice: )
    dice_face_values_count = build_dice_face_values_set(dice).select { |_k, v| v == 4 }
    score_four_of_a_kind(dice_face_values_count)
  end

  def self.score_four_of_a_kind(dice_face_values_count)
    dice_face_values_count.max_by { |k, v| k }.reduce(&:*)
  end

  def self.yatzy( dice: )
    dice_face_values_count = build_dice_face_values_set(dice).select { |_k, v| v == 5 }
    score_yatzy(dice_face_values_count)
  end

  def self.score_yatzy(dice_face_values_count)
    dice_face_values_count.size == 1 ? YATZY_SCORE : 0
  end

  def self.full_house( dice: )
    dice_face_values_count = build_dice_face_values_set(dice)
    three_of_a_kind = dice_face_values_count.key(3)
    pair = dice_face_values_count.key(2)

    three_of_a_kind && pair ? score_full_house(dice) : 0
  end

  def self.score_full_house(dice)
    dice.reduce(&:+)
  end

  private

  def self.build_dice_face_values_set( dice )
    dice.uniq.each_with_object({}) do |dice_face_value, memo|
      memo.store(dice_face_value, dice.count(dice_face_value))
    end
  end

end
