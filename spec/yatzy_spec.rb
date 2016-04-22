require "spec_helper"
require_relative "../yatzy"

RSpec.describe Yatzy do
  describe "#chance" do
    it "returns the sum of all dice provided" do
      result = Yatzy.chance(2, 3, 1, 2, 2)

      expect(result).to eq(10)
    end
  end

  describe "#yatzy" do
    it "scores 50 when all dice are matching" do
      result = Yatzy.yatzy([4, 4, 4, 4, 4])

      expect(result).to eq(50)
    end

    it "scores 0 when all dice are not matching" do
      result = Yatzy.yatzy([6, 6, 6, 6, 3])

      expect(result).to eq(0)
    end
  end

  describe "#singles" do
    it "scores the sum of all the number provided" do
      expect(Yatzy.singles(number: 3, dice: [1, 3, 3, 1, 1])).to eq(6)
    end

    it "scores zero when no dice match the number provided" do
      expect(Yatzy.singles(number: 3, dice: [1, 2, 1, 1, 1])).to eq(0)
    end

    it "does not accept numbers over 6" do
      expect { Yatzy.singles(number: 7, dice: [1, 2, 1, 1, 1]) }.to raise_error("you can only use 6-sided dice (number must be between 1 and 6)")
    end

    it "does not accept numbers below 1" do
      expect { Yatzy.singles(number: 0, dice: [1, 2, 1, 1, 1]) }.to raise_error("you can only use 6-sided dice (number must be between 1 and 6)")
    end
  end

  it "test_one_pair" do
    expect(Yatzy.score_pair(dice: [3, 4, 3, 5, 6])).to eq(6)
    expect(Yatzy.score_pair(dice: [5, 3, 3, 3, 5])).to eq(10)
    expect(Yatzy.score_pair(dice: [5, 3, 6, 6, 5])).to eq(12)
  end

  it "test_two_Pair" do
    expect(Yatzy.two_pair(dice: [3, 3, 5, 4, 5])).to eq(16)
    expect(Yatzy.two_pair(dice: [3, 3, 5, 5, 5])).to eq(16)
    expect(Yatzy.two_pair(dice: [1, 1, 2, 2, 5])).to eq(6)
    expect(Yatzy.two_pair(dice: [1, 1, 3, 4, 5])).to eq(0)
  end

  it "test_three_of_a_kind" do
    aggregate_failures do
      expect(Yatzy.three_of_a_kind(dice: [3, 3, 3, 4, 5])).to eq(9)
      expect(Yatzy.three_of_a_kind(dice: [3, 3, 3, 3, 5])).to eq(9)
      expect(Yatzy.three_of_a_kind(dice: [1, 1, 1, 3, 5])).to eq(3)
      expect(Yatzy.three_of_a_kind(dice: [1, 1, 1, 1, 1])).to eq(3)
    end
  end

  it "test_four_of_a_knd" do
    expect(12).to eq(Yatzy.four_of_a_kind(3, 3, 3, 3, 5))
    expect(20).to eq(Yatzy.four_of_a_kind(5, 5, 5, 4, 5))
    expect(12).to eq(Yatzy.four_of_a_kind(3, 3, 3, 3, 3))
  end

  it "test_smallStraight()" do
    expect(15).to eq(Yatzy.smallStraight(1, 2, 3, 4, 5))
    expect(15).to eq(Yatzy.smallStraight(2, 3, 4, 5, 1))
    expect(0).to eq(Yatzy.smallStraight(1, 2, 2, 4, 5))
  end

  it "test_largeStraight" do
    expect(20).to eq(Yatzy.largeStraight(6, 2, 3, 4, 5))
    expect(20).to eq(Yatzy.largeStraight(2, 3, 4, 5, 6))
    expect(0).to eq(Yatzy.largeStraight(1, 2, 2, 4, 5))
  end

  it "test_fullHouse()" do
    expect(18).to eq(Yatzy.fullHouse(6, 2, 2, 2, 6))
    expect(0).to eq(Yatzy.fullHouse(2, 3, 4, 5, 6))
  end


end