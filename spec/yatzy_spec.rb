require "spec_helper"
require_relative "../yatzy"

RSpec.describe "Yatzy" do
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

  describe "#ones" do
    it "scores the sum of all the ones" do
      expect(Yatzy.ones(1, 2, 1, 1, 1)).to eq(4)
    end

    it "scores 0 for no 1's" do
      expect(Yatzy.ones(6, 2, 2, 4, 5)).to eq(0)
    end
  end

  describe "#twos" do
    it "scores the sum of all the twos" do
      expect(Yatzy.twos(1, 2, 3, 2, 6)).to eq(4)
    end
  end

  describe "#threes" do
    it "scores the sum of all the threes" do
      expect(Yatzy.threes(2, 3, 3, 3, 3)).to eq(12)
    end
  end

  describe "#fours" do
    it "scores the sum of all the fours" do
      expect(Yatzy.fours(4, 4, 5, 5, 5)).to eq(8)
    end
  end

  it "test_fives()" do
    expect(10).to eq(Yatzy.new(4, 4, 4, 5, 5).fives())
    expect(15).to eq(Yatzy.new(4, 4, 5, 5, 5).fives())
    expect(20).to eq(Yatzy.new(4, 5, 5, 5, 5).fives())
  end

  it "test_sixes_test" do
    expect(0).to eq(Yatzy.new(4, 4, 4, 5, 5).sixes())
    expect(6).to eq(Yatzy.new(4, 4, 6, 5, 5).sixes())
    expect(18).to eq(Yatzy.new(6, 5, 6, 6, 5).sixes())
  end

  it "test_one_pair" do
    expect(6).to eq(Yatzy.score_pair(3, 4, 3, 5, 6))
    expect(10).to eq(Yatzy.score_pair(5, 3, 3, 3, 5))
    expect(12).to eq(Yatzy.score_pair(5, 3, 6, 6, 5))
  end

  it "test_two_Pair" do
    expect(16).to eq(Yatzy.two_pair(3, 3, 5, 4, 5))
    expect(16).to eq(Yatzy.two_pair(3, 3, 5, 5, 5))
  end

  it "test_three_of_a_kind()" do
    expect(9).to eq(Yatzy.three_of_a_kind(3, 3, 3, 4, 5))
    expect(15).to eq(Yatzy.three_of_a_kind(5, 3, 5, 4, 5))
    expect(9).to eq(Yatzy.three_of_a_kind(3, 3, 3, 3, 5))
  end

  it "test_four_of_a_knd" do
    expect(12).to eq(Yatzy.four_of_a_kind(3, 3, 3, 3, 5))
    expect(20).to eq(Yatzy.four_of_a_kind(5, 5, 5, 4, 5))
    expect(9).to eq(Yatzy.three_of_a_kind(3, 3, 3, 3, 3))
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