class Yatzy
  def initialize(d1, d2, d3, d4, _5)
    @dice = [0]*5
    @dice[0] = d1
    @dice[1] = d2
    @dice[2] = d3
    @dice[3] = d4
    @dice[4] = _5
  end

  def self.chance(*dice)
    dice.reduce(&:+)
  end

  def self.yatzy(dice)
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

    ## this is likely an enumerable of some sort
    dice_face_values_count = {}
    dice.uniq.each do |dice_face_value|
      dice_face_values_count.store( dice_face_value, dice.count(dice_face_value) )
    end
    dice_face_values_count
  end

  def self.score_pair(dice: )
    dice_face_values_count = build_dice_face_values_set(dice).reject { |_k, v| v == 1 }
    dice_face_values_count.keys.max * 2
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

  def self.four_of_a_kind( _1,  _2,  d3,  d4,  d5)
    tallies = [0]*6
    tallies[_1-1] += 1
    tallies[_2-1] += 1
    tallies[d3-1] += 1
    tallies[d4-1] += 1
    tallies[d5-1] += 1
    for i in (0..6)
      if (tallies[i] >= 4)
        return (i+1) * 4
      end
    end
    return 0
  end

  def self.smallStraight( d1,  d2,  d3,  d4,  d5)
    tallies = [0]*6
    tallies[d1-1] += 1
    tallies[d2-1] += 1
    tallies[d3-1] += 1
    tallies[d4-1] += 1
    tallies[d5-1] += 1
    (tallies[0] == 1 and
      tallies[1] == 1 and
      tallies[2] == 1 and
      tallies[3] == 1 and
      tallies[4] == 1) ? 15 : 0
  end

  def self.largeStraight( d1,  d2,  d3,  d4,  d5)
    tallies = [0]*6
    tallies[d1-1] += 1
    tallies[d2-1] += 1
    tallies[d3-1] += 1
    tallies[d4-1] += 1
    tallies[d5-1] += 1
    if (tallies[1] == 1 and tallies[2] == 1 and tallies[3] == 1 and tallies[4] == 1 and tallies[5] == 1)
      return 20
    end
    return 0
  end

  def self.fullHouse( d1,  d2,  d3,  d4,  d5)
    tallies = []
    _2 = false
    i = 0
    _2_at = 0
    _3 = false
    _3_at = 0

    tallies = [0]*6
    tallies[d1-1] += 1
    tallies[d2-1] += 1
    tallies[d3-1] += 1
    tallies[d4-1] += 1
    tallies[d5-1] += 1

    for i in Array 0..5
      if (tallies[i] == 2)
        _2 = true
        _2_at = i+1
      end
    end

    for i in Array 0..5
      if (tallies[i] == 3)
        _3 = true
        _3_at = i+1
      end
    end

    if (_2 and _3)
      return _2_at * 2 + _3_at * 3
    else
      return 0
    end
  end
end
