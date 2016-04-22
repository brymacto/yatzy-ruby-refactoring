class Yatzy
  def self.chance(dice: )
    dice.reduce(&:+)
  end

  def self.yatzy(dice: )
    if dice.uniq.size == 1
      return 50
    else
      return 0
    end
  end

  def self.singles(number: , dice: )
    raise "you can only use 6-sided dice (number must be between 1 and 6)" if (number < 1) || (number > 6)
    return 0 unless dice.include?(number)
    dice.select { |die| die == number }.reduce(&:+)
  end

  def self.build_dice_face_values_set(dice)
    dice.uniq.each_with_object({}) do |dice_face_value, memo|
      memo.store(dice_face_value, dice.count(dice_face_value))
    end
  end

  def self.score_pair(dice: )
    dice_face_values_count = build_dice_face_values_set(dice).reject { |_k, v| v != 2 }

    if dice_face_values_count.size != 0
      dice_face_values_count.keys.max * 2
    else
      0
    end
  end

  def self.two_pair( dice: )
    dice_face_values_count = build_dice_face_values_set(dice).reject { |_k, v| v == 1 }

    if dice_face_values_count.keys.size == 2
      dice_face_values_count.keys.reduce(&:+) * 2
    else
      0
    end
  end

  def self.three_of_a_kind( dice: )
    dice_face_values_count = build_dice_face_values_set(dice)

    remaining_dice = dice_face_values_count.reject { |_k, v| v < 3 }

    if remaining_dice.size > 0
      remaining_dice.keys.max * 3
    else
      0
    end
  end

  def self.four_of_a_kind( dice: )
    dice_face_values_count = build_dice_face_values_set(dice)

    remaining_dice = dice_face_values_count.reject { |_k, v| v < 4 }

    if remaining_dice.size > 0
      remaining_dice.keys.max * 4
    else
      0
    end
  end

  def self.small_straight( dice: )
    return 15 if dice.reduce(&:+) == 15
    0
  end

  def self.large_straight( dice: )
    return 20 if dice.reduce(&:+) == 20
    0
  end

  def self.full_house( dice: )
    dice_face_values_count = build_dice_face_values_set(dice)

    three_of_a_kind = dice_face_values_count.key(3)
    pair = dice_face_values_count.key(2)

    if three_of_a_kind && pair
      dice.reduce(&:+)
    else
      0
    end

  end

end
