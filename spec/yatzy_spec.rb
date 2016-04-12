require "spec_helper"
require_relative "../yatzy"

RSpec.describe "Yatzy" do
  describe "#chance" do
    it "returns the sum of all dice provided" do
      result = Yatzy.chance(2,3,1,2,2)

      expect(10).to eq(result)
    end
  end

  it "test_yatzy_scores_50" do
    expected = 50
    actual = Yatzy.yatzy([4,4,4,4,4])
    expect(expected).to eq(actual)
    expect(50).to eq(Yatzy.yatzy([6,6,6,6,6]))
    expect(0).to eq(Yatzy.yatzy([6,6,6,6,3]))
  end

  it "test_1s" do
    expect(Yatzy.ones(1,2,3,4,5)).to eq (1)
    expect(2).to eq(Yatzy.ones(1,2,1,4,5))
    expect(0).to eq(Yatzy.ones(6,2,2,4,5))
    expect(4).to eq(Yatzy.ones(1,2,1,1,1))
  end

  it "test_2s" do
    expect(Yatzy.twos(1,2,3,2,6)).to eq(4)
    expect(Yatzy.twos(2,2,2,2,2)).to eq(10)
  end

  it "test_threes" do
    expect(6).to eq(Yatzy.threes(1,2,3,2,3))
    expect(12).to eq(Yatzy.threes(2,3,3,3,3))
  end

  it "test_fours_test" do
    expect(12).to eq(Yatzy.new(4,4,4,5,5).fours)
    expect(8).to eq(Yatzy.new(4,4,5,5,5).fours)
    expect(4).to eq(Yatzy.new(4,5,5,5,5).fours)
  end

  it "test_fives()" do
    expect(10).to eq(Yatzy.new(4,4,4,5,5).fives())
    expect(15).to eq(Yatzy.new(4,4,5,5,5).fives())
    expect(20).to eq(Yatzy.new(4,5,5,5,5).fives())
  end

  it "test_sixes_test" do
    expect(0).to eq(Yatzy.new(4,4,4,5,5).sixes())
    expect(6).to eq(Yatzy.new(4,4,6,5,5).sixes())
    expect(18).to eq(Yatzy.new(6,5,6,6,5).sixes())
  end

  it "test_one_pair" do
    expect(6).to eq(Yatzy.score_pair(3,4,3,5,6))
    expect(10).to eq(Yatzy.score_pair(5,3,3,3,5))
    expect(12).to eq(Yatzy.score_pair(5,3,6,6,5))
  end

  it "test_two_Pair" do
    expect(16).to eq(Yatzy.two_pair(3,3,5,4,5))
    expect(16).to eq(Yatzy.two_pair(3,3,5,5,5))
  end

  it "test_three_of_a_kind()" do
    expect(9).to eq(Yatzy.three_of_a_kind(3,3,3,4,5))
    expect(15).to eq(Yatzy.three_of_a_kind(5,3,5,4,5))
    expect(9).to eq(Yatzy.three_of_a_kind(3,3,3,3,5))
  end

  it "test_four_of_a_knd" do
    expect(12).to eq(Yatzy.four_of_a_kind(3,3,3,3,5))
    expect(20).to eq(Yatzy.four_of_a_kind(5,5,5,4,5))
    expect(9).to eq(Yatzy.three_of_a_kind(3,3,3,3,3))
    expect(12).to eq(Yatzy.four_of_a_kind(3,3,3,3,3))
  end

  it "test_smallStraight()" do
    expect(15).to eq(Yatzy.smallStraight(1,2,3,4,5))
    expect(15).to eq(Yatzy.smallStraight(2,3,4,5,1))
    expect(0).to eq(Yatzy.smallStraight(1,2,2,4,5))
  end

  it "test_largeStraight" do
    expect(20).to eq(Yatzy.largeStraight(6,2,3,4,5))
    expect(20).to eq(Yatzy.largeStraight(2,3,4,5,6))
    expect(0).to eq(Yatzy.largeStraight(1,2,2,4,5))
  end

  it "test_fullHouse()" do
    expect(18).to eq(Yatzy.fullHouse(6,2,2,2,6))
    expect(0).to eq(Yatzy.fullHouse(2,3,4,5,6))
  end


end