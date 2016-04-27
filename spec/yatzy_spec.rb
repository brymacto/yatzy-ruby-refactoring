require "spec_helper"
require_relative "../lib/yatzy"

RSpec.describe Yatzy do
  describe "@dice" do
    it "raises an error if 5 dice are not used" do
      expect{Yatzy.new(dice: [1,2,3,4,5,6])}.to raise_error("You need to use five dice")
      expect{Yatzy.new(dice: [1,2,3,4])}.to raise_error("You need to use five dice")
    end
  end

  describe "#roll" do
    it "returns a set of 5 dice" do
      expect(Yatzy.roll.size).to eq(5)
    end

    it "returns dice that are random" do
      expect(Yatzy.roll).not_to eq(Yatzy.roll)
    end
  end

  describe "#best_option" do
    it "returns an array of the highest scoring set of dice" do
      yatzy = Yatzy.new(dice: [1, 1, 1, 1, 1]).best_option
      small_straight = Yatzy.new(dice: [1, 2, 3, 4, 5]).best_option
      large_straight = Yatzy.new(dice: [2, 3, 4, 5, 6]).best_option
      four_kind = Yatzy.new(dice: [4, 4, 4, 4, 1]).best_option

      expect(yatzy).to eq(["YatzyScore", Yatzy::YATZY_SCORE])
      expect(small_straight).to eq(["SmallStraight", Yatzy::SMALL_STRAIGHT_SCORE])
      expect(large_straight).to eq(["LargeStraight", Yatzy::LARGE_STRAIGHT_SCORE])
      expect(four_kind).to eq(["FourOfAKind", 4 * 4])
    end
  end

  describe "Object" do
    dice_roll = [1, 1, 1, 1, 1]
    let(:game) { Yatzy.new(dice: dice_roll) }
    let(:scores) { game.scores }

    it "has attributes" do
      expect(game).to have_attributes(
                          dice: [1, 1, 1, 1, 1],
                          dice_face_values_set: {1 => 5},
                          sum_of_dice: 5,
                      )
    end

    describe "@scores attribute" do
      it "is a hash with keys" do
        expect(scores).to be_a(Hash)
        # expect(scores).to include("chance")
        expect(scores).to include("SmallStraight")
        expect(scores).to include("LargeStraight")
        expect(scores).to include("Singles")
        expect(scores).to include("OnePair")
        expect(scores).to include("TwoPair")
        expect(scores).to include("ThreeOfAKind")
        expect(scores).to include("FourOfAKind")
        expect(scores).to include("YatzyScore")
        expect(scores).to include("FullHouse")
      end

      describe "@score.fetch('chance')" do
        xit "returns the sum of all values for chance" do
          result = Yatzy.new(dice: [2, 3, 1, 2, 2]).scores.fetch("Chance")

          expect(result).to eq(2 + 3 + 1 + 2 + 2)
          expect(scores.fetch("Chance")).to eq(game.sum_of_dice)
        end
      end

      describe "@score.fetch('small straight')" do
        it "returns the sum for a small straight" do
          result = Yatzy.new(dice: [1, 2, 3, 4, 5]).scores.fetch("SmallStraight")
          result2 = Yatzy.new(dice: [2, 3, 4, 5, 1]).scores.fetch("SmallStraight")


          expect(result).to eq(Yatzy::SMALL_STRAIGHT_SCORE)
          expect(result2).to eq(Yatzy::SMALL_STRAIGHT_SCORE)
        end

        it "returns 0 when there is no small straight" do
          result3 = Yatzy.new(dice: [1, 2, 2, 4, 5]).scores.fetch("SmallStraight")

          expect(result3).to eq(0)
          expect(scores.fetch("SmallStraight")).to eq(0)
        end
      end

      describe "@score.fetch('large straight')" do
        it "finds the sum for a large straight" do
          result = Yatzy.new(dice: [6, 2, 3, 4, 5]).scores.fetch("LargeStraight")
          result2 = Yatzy.new(dice: [2, 3, 4, 5, 6]).scores.fetch("LargeStraight")


          expect(result).to eq(Yatzy::LARGE_STRAIGHT_SCORE)
          expect(result2).to eq(Yatzy::LARGE_STRAIGHT_SCORE)
        end

        it "returns 0 if there is no large straight" do
          result3 = Yatzy.new(dice: [1, 2, 2, 4, 5]).scores.fetch("LargeStraight")

          expect(result3).to eq(0)
          expect(scores.fetch("LargeStraight")).to eq(0)
        end
      end

      describe "@scores.fetch('singles')" do
        it "returns the sum of the highest combination for each number in the roll" do
          result = Yatzy.new(dice: [1, 3, 3, 1, 1]).scores.fetch("Singles")
          result2 = Yatzy.new(dice: [6, 1, 1, 1, 1]).scores.fetch("Singles")

          expect(result).to eq(3 + 3)
          expect(result2).to eq(6)
          expect(scores.fetch("Singles")).to eq(1 + 1 + 1 + 1 + 1)
        end
      end

      describe "@scores.fetch('one pair')" do
        it "returns the value of the highest possible pair" do
          result = Yatzy.new(dice: [3, 4, 3, 5, 6]).scores.fetch("OnePair")
          result2 = Yatzy.new(dice: [5, 3, 3, 3, 5]).scores.fetch("OnePair")
          result3 = Yatzy.new(dice: [5, 3, 6, 6, 5]).scores.fetch("OnePair")

          expect(result).to eq(3 + 3)
          expect(result2).to eq(5 + 5)
          expect(result3).to eq(6 + 6)
        end

        it "returns 0 if a pair cannot be made" do
          result4 = Yatzy.new(dice: [1, 2, 3, 5, 6]).scores.fetch("OnePair")

          expect(result4).to eq(0)
        end
      end

      describe "@scores.fetch('two pair')" do
        it "returns the value of the two highest possible pairs" do
          result = Yatzy.new(dice: [3, 3, 5, 4, 5]).scores.fetch("TwoPair")
          result2 = Yatzy.new(dice: [1, 1, 2, 2, 5]).scores.fetch("TwoPair")

          expect(result).to eq(3 + 3 + 5 + 5)
          expect(result2).to eq(1 + 1 + 2 + 2)
        end

        it "returns 0 if two pairs do not exist, or if three/four of a kind or yatzy" do
          result3 = Yatzy.new(dice: [1, 1, 3, 4, 5]).scores.fetch("TwoPair")

          expect(result3).to eq(0)
          expect(scores.fetch("TwoPair")).to eq(0)  # not two pair, but a yatzy
        end
      end

      describe "@scores.fetch('three of a kind')" do
        it "returns the value of three of the same number" do
          result = Yatzy.new(dice: [3, 3, 3, 4, 5]).scores.fetch("ThreeOfAKind")
          result2 = Yatzy.new(dice: [1, 1, 1, 3, 5]).scores.fetch("ThreeOfAKind")

          expect(result).to eq(3 + 3 + 3)
          expect(result2).to eq(1 + 1 + 1)
        end

        it "returns 0 if three of a kind does not exist, or there is a four of a kind or yatzy" do
          result3 = Yatzy.new(dice: [3, 3, 3, 3, 5]).scores.fetch("ThreeOfAKind")

          expect(result3).to eq(0)
          expect(scores.fetch("ThreeOfAKind")).to eq(0)
        end
      end

      describe "@scores.fetch('four of a kind')" do
        it "returns the value of four of the same number" do
          result = Yatzy.new(dice: [3, 3, 3, 3, 5]).scores.fetch("FourOfAKind")
          result2 = Yatzy.new(dice: [5, 5, 5, 4, 5]).scores.fetch("FourOfAKind")

          expect(result).to eq(3 + 3 + 3 + 3)
          expect(result2).to eq(5 + 5 + 5 + 5)
        end

        it "returns 0 when four of a kind does not exit, or there is a yatzy" do
          result3 = Yatzy.new(dice: [2, 2, 2, 1, 1]).scores.fetch("FourOfAKind")

          expect(result3).to eq(0)
          expect(scores.fetch("FourOfAKind")).to eq(0)
        end
      end

      describe "@scores.fetch('YatzyScore')" do
        it "returns 50 when all dice are matching" do
          result = Yatzy.new(dice: [4, 4, 4, 4, 4]).scores.fetch("YatzyScore")

          expect(result).to eq(Yatzy::YATZY_SCORE)
        end

        it "returns 0 when all dice are not matching" do
          result = Yatzy.new(dice: [6, 6, 6, 6, 3]).scores.fetch("YatzyScore")

          expect(result).to eq(0)
        end
      end

      describe "@scores.fetch('full house')" do
        it "returns the sum of all the dice if its a full house" do
          result = Yatzy.new(dice: [6, 2, 2, 2, 6]).scores.fetch("FullHouse")
          result2 = Yatzy.new(dice: [6, 6, 2, 2, 6]).scores.fetch("FullHouse")

          expect(result).to eq(2 + 2 + 2 + 6 + 6)
          expect(result2).to eq(6 + 6 + 6 + 2 + 2)
        end

        it "returns 0 if there isn't a full house" do
          result3 = Yatzy.new(dice: [2, 3, 4, 5, 6]).scores.fetch("FullHouse")

          expect(result3).to eq(0)
          expect(scores.fetch("FullHouse")).to eq(0)
        end
      end
    end

  end
end