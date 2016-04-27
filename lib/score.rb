class Score
  def initialize(dice:, dice_face_values_set: build_dice_face_values_set)
    @dice = dice
    @dice_face_values_set = dice_face_values_set
  end

  private

  def build_dice_face_values_set
    @dice.uniq.each_with_object({}) do |dice_face_value, memo|
      memo.store(dice_face_value, @dice.count(dice_face_value))
    end
  end
end

class SmallStraight < Score
  def score
    @dice.reduce(&:+) == Yatzy::SMALL_STRAIGHT_SCORE ? Yatzy::SMALL_STRAIGHT_SCORE : 0
  end
end

class LargeStraight < Score
  def score
    @dice.reduce(&:+) == Yatzy::LARGE_STRAIGHT_SCORE ? Yatzy::LARGE_STRAIGHT_SCORE : 0
  end
end

class OnePair < Score
  def score
    dice_face_values_count = @dice_face_values_set.select { |_k, v| v == 2 }

    return 0 if dice_face_values_count.empty?
    dice_face_values_count.max_by { |k, v| k * v }.reduce(&:*)
  end
end

class TwoPair < Score
  def score
    dice_face_values_count = @dice_face_values_set.select { |_k, v| v == 2 }

    return 0 if dice_face_values_count.size != 2
    dice_face_values_count.map { |k, v| k * v }.reduce(&:+)
  end
end

class FourOfAKind < Score
  def score
    dice_face_values_count = @dice_face_values_set.select { |_k, v| v == 4 }

    return 0 if dice_face_values_count.empty?
    dice_face_values_count.max_by { |k, v| k }.reduce(&:*)
  end
end

class ThreeOfAKind < Score
  def score
    dice_face_values_count = @dice_face_values_set.select { |_k, v| v == 3 }

    return 0 if dice_face_values_count.empty?
    dice_face_values_count.max_by { |k, v| k }.reduce(&:*)
  end
end

class YatzyScore < Score
  def score
    dice_face_values_count = @dice_face_values_set.select { |_k, v| v == 5 }

    return 0 if dice_face_values_count.empty?
    Yatzy::YATZY_SCORE
  end
end

class FullHouse < Score
  def score
    three_of_a_kind = @dice_face_values_set.key(3)
    pair = @dice_face_values_set.key(2)

    three_of_a_kind && pair ? @dice.reduce(&:+) : 0
  end
end

class Singles < Score
  def score
    @dice_face_values_set.max_by { |k, v| k * v }.reduce(&:*)
  end
end