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
        expect(scores).to include("chance")
        expect(scores).to include("small straight")
        expect(scores).to include("large straight")
        expect(scores).to include("singles")
        expect(scores).to include("one pair")
        expect(scores).to include("two pair")
        expect(scores).to include("three of a kind")
        expect(scores).to include("four of a kind")
        expect(scores).to include("yatzy")
        expect(scores).to include("full house")
      end

      it "sums all values for chance" do
        result = Yatzy.new(dice: [2, 3, 1, 2, 2]).scores.fetch("chance")

        expect(result).to eq(2 + 3 + 1 + 2 + 2)
        expect(scores.fetch("chance")).to eq(game.sum_of_dice)
      end

      it "finds the sum for a small straight" do
        result = Yatzy.new(dice: [1, 2, 3, 4, 5]).scores.fetch("small straight")
        result2 = Yatzy.new(dice: [2, 3, 4, 5, 1]).scores.fetch("small straight")
        result3 = Yatzy.new(dice: [1, 2, 2, 4, 5]).scores.fetch("small straight")

        expect(result).to eq(Yatzy::SMALL_STRAIGHT_SCORE)
        expect(result2).to eq(Yatzy::SMALL_STRAIGHT_SCORE)
        expect(result3).to eq(0)
        expect(scores.fetch("small straight")).to eq(0)
      end

      it "finds the sum for a large straight" do
        result = Yatzy.new(dice: [6, 2, 3, 4, 5]).scores.fetch("large straight")
        result2 = Yatzy.new(dice: [2, 3, 4, 5, 6]).scores.fetch("large straight")
        result3 = Yatzy.new(dice: [1, 2, 2, 4, 5]).scores.fetch("large straight")

        expect(result).to eq(Yatzy::LARGE_STRAIGHT_SCORE)
        expect(result2).to eq(Yatzy::LARGE_STRAIGHT_SCORE)
        expect(result3).to eq(0)
        expect(scores.fetch("large straight")).to eq(0)
      end

      describe "@scores.fetch('singles')" do
        it "returns the sum of the highest combination for each number in the roll" do
          result = Yatzy.new(dice: [1, 3, 3, 1, 1]).scores.fetch("singles")

          expect(result).to eq(3 + 3)
          expect(scores.fetch("singles")).to eq(1 + 1 + 1 + 1 + 1)
        end
      end

      describe "@scores.fetch('one pair')" do
        it "returns the value of the highest possible pair" do
          result = Yatzy.new(dice: [3, 4, 3, 5, 6]).scores.fetch("one pair")
          result2 = Yatzy.new(dice: [5, 3, 3, 3, 5]).scores.fetch("one pair")
          result3 = Yatzy.new(dice: [5, 3, 6, 6, 5]).scores.fetch("one pair")

          expect(result).to eq(3 + 3)
          expect(result2).to eq(5 + 5)
          expect(result3).to eq(6 + 6)
        end

        it "returns 0 if a pair cannot be made" do
          result = Yatzy.new(dice: [1, 2, 3, 5, 6]).scores.fetch("one pair")

          expect(result).to eq(0)
        end
      end

      describe "@scores.fetch('two pair')" do
        it "returns the value of the two highest possible pairs" do
          result = Yatzy.new(dice: [3, 3, 5, 4, 5]).scores.fetch("two pair")
          result2 = Yatzy.new(dice: [1, 1, 2, 2, 5]).scores.fetch("two pair")

          expect(result).to eq(3 + 3 + 5 + 5)
          expect(result2).to eq(1 + 1 + 2 + 2)
        end

        it "returns 0 if two pairs do not exist, or if three/four of a kind or yatzy" do
          result3 = Yatzy.new(dice: [1, 1, 3, 4, 5]).scores.fetch("two pair")

          expect(result3).to eq(0)
          expect(scores.fetch("two pair")).to eq(0)  # not two pair, but a yatzy
        end
      end

      describe "@scores.fetch('three of a kind')" do
        it "returns the value of three of the same number" do
          result = Yatzy.new(dice: [3, 3, 3, 4, 5]).scores.fetch("three of a kind")
          result2 = Yatzy.new(dice: [1, 1, 1, 3, 5]).scores.fetch("three of a kind")

          expect(result).to eq(3 + 3 + 3)
          expect(result2).to eq(1 + 1 + 1)
        end

        it "returns 0 if three of a kind does not exist, or there is a four of a kind or yatzy" do
          result3 = Yatzy.new(dice: [3, 3, 3, 3, 5]).scores.fetch("three of a kind")

          expect(result3).to eq(0)
          expect(scores.fetch("three of a kind")).to eq(0)
        end
      end

      describe "@scores.fetch('four of a kind')" do
        it "returns the value of four of the same number" do
          result = Yatzy.new(dice: [3, 3, 3, 3, 5]).scores.fetch("four of a kind")
          result2 = Yatzy.new(dice: [5, 5, 5, 4, 5]).scores.fetch("four of a kind")

          expect(result).to eq(3 + 3 + 3 + 3)
          expect(result2).to eq(5 + 5 + 5 + 5)
        end

        it "returns 0 when four of a kind does not exit, or there is a yatzy" do
          result3 = Yatzy.new(dice: [2, 2, 2, 1, 1]).scores.fetch("four of a kind")

          expect(result3).to eq(0)
          expect(scores.fetch("four of a kind")).to eq(0)
        end
      end

      describe "@scores.fetch('yatzy')" do
        it "returns 50 when all dice are matching" do
          result = Yatzy.new(dice: [4, 4, 4, 4, 4]).scores.fetch("yatzy")

          expect(result).to eq(Yatzy::YATZY_SCORE)
        end

        it "returns 0 when all dice are not matching" do
          result = Yatzy.new(dice: [6, 6, 6, 6, 3]).scores.fetch("yatzy")

          expect(result).to eq(0)
        end
      end

      describe "@scores.fetch('full house')" do
        it "returns the sum of all the dice if its a full house" do
          result = Yatzy.new(dice: [6, 2, 2, 2, 6]).scores.fetch("full house")
          result2 = Yatzy.new(dice: [6, 6, 2, 2, 6]).scores.fetch("full house")

          expect(result).to eq(2 + 2 + 2 + 6 + 6)
          expect(result2).to eq(6 + 6 + 6 + 2 + 2)
        end

        it "returns 0 if there isn't a full house" do
          result3 = Yatzy.new(dice: [2, 3, 4, 5, 6]).scores.fetch("full house")

          expect(result3).to eq(0)
          expect(scores.fetch("full house")).to eq(0)
        end
      end
    end

  end
end