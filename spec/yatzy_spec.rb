require "spec_helper"
require_relative "../yatzy"

RSpec.describe Yatzy do
  describe "#roll" do
    it "returns a set of 5 dice" do
      expect(Yatzy.roll.size).to eq(5)
    end

    it "returns dice that are random" do
      expect(Yatzy.roll).not_to eq(Yatzy.roll)
    end
  end

  describe "#chance" do
    it "returns the sum of all dice provided" do
      result = Yatzy.chance(dice: [2, 3, 1, 2, 2])

      expect(result).to eq(2 + 3 + 1 + 2 + 2)
    end
  end

  it "test_small_straight" do
    aggregate_failures do
      expect( Yatzy.small_straight(dice: [1, 2, 3, 4, 5]) ).to eq(Yatzy::SMALL_STRAIGHT_SCORE)
      expect( Yatzy.small_straight(dice: [2, 3, 4, 5, 1]) ).to eq(Yatzy::SMALL_STRAIGHT_SCORE)
      expect( Yatzy.small_straight(dice: [1, 2, 2, 4, 5]) ).to eq(0)
    end
  end

  it "test_large_straight" do
    aggregate_failures do
      expect( Yatzy.large_straight(dice: [6, 2, 3, 4, 5]) ).to eq(Yatzy::LARGE_STRAIGHT_SCORE)
      expect( Yatzy.large_straight(dice: [2, 3, 4, 5, 6]) ).to eq(Yatzy::LARGE_STRAIGHT_SCORE)
      expect( Yatzy.large_straight(dice: [1, 2, 2, 4, 5]) ).to eq(0)
    end
  end

  describe "#singles" do
    it "scores the sum of all the number provided" do
      expect(Yatzy.singles(number: 3, dice: [1, 3, 3, 1, 1])).to eq(3 + 3)
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
    aggregate_failures do
      expect(Yatzy.one_pair(dice: [3, 4, 3, 5, 6])).to eq(3 + 3)
      expect(Yatzy.one_pair(dice: [5, 3, 3, 3, 5])).to eq(5 + 5)
      expect(Yatzy.one_pair(dice: [5, 3, 6, 6, 5])).to eq(6 + 6)
    end
  end

  it "test_two_Pair" do
    aggregate_failures do
      expect(Yatzy.two_pair(dice: [3, 3, 5, 4, 5])).to eq(3 + 3 + 5 + 5)
      expect(Yatzy.two_pair(dice: [1, 1, 2, 2, 5])).to eq(1 + 1 + 2 + 2)
      expect(Yatzy.two_pair(dice: [1, 1, 3, 4, 5])).to eq(0)
    end
  end

  it "test_three_of_a_kind" do
    aggregate_failures do
      expect(Yatzy.three_of_a_kind(dice: [3, 3, 3, 4, 5])).to eq(3 + 3 + 3)
      expect(Yatzy.three_of_a_kind(dice: [1, 1, 1, 3, 5])).to eq(1 + 1 + 1)
    end
  end

  it "test_four_of_a_knd" do
    aggregate_failures do
      expect(Yatzy.four_of_a_kind(dice: [3, 3, 3, 3, 5])).to eq(3 + 3 + 3 + 3)
      expect(Yatzy.four_of_a_kind(dice: [5, 5, 5, 4, 5])).to eq(5 + 5 + 5 + 5)
    end
  end

  describe "#yatzy" do
    it "scores 50 when all dice are matching" do
      result = Yatzy.yatzy(dice: [4, 4, 4, 4, 4])

      expect(result).to eq(Yatzy::YATZY_SCORE)
    end

    it "scores 0 when all dice are not matching" do
      result = Yatzy.yatzy(dice: [6, 6, 6, 6, 3])

      expect(result).to eq(0)
    end
  end

  it "test_full_house()" do
    aggregate_failures do
      expect( Yatzy.full_house(dice: [6, 2, 2, 2, 6]) ).to eq(2 + 2 + 2 + 6 + 6)
      expect( Yatzy.full_house(dice: [6, 6, 2, 2, 6]) ).to eq(6 + 6 + 6 + 2 + 2)
      expect( Yatzy.full_house(dice: [2, 3, 4, 5, 6]) ).to eq(0)
    end
  end

  describe "Object" do
    dice_roll = [1, 1, 1, 1, 1]
    let(:game) { Yatzy.new(dice: dice_roll) }

    it "has attributes" do
      expect(game).to have_attributes(
                          dice: [1, 1, 1, 1, 1],
                          dice_face_values_set: {1 => 5},
                          sum_of_dice: 5,
                      )
    end

    it "@scores" do
      expect(game.scores).to be_a(Hash)
      expect(game.scores).to include("chance".to_sym)
      expect(game.scores).to include("small straight".to_sym)
      expect(game.scores).to include("large straight".to_sym)
      expect(game.scores).to include("singles".to_sym)
      expect(game.scores).to include("one pair".to_sym)
      expect(game.scores).to include("two pair".to_sym)
      expect(game.scores).to include("three of a kind".to_sym)
      expect(game.scores).to include("four of a kind".to_sym)
      expect(game.scores).to include("yatzy".to_sym)
      expect(game.scores).to include("full house".to_sym)
    end

  end
end