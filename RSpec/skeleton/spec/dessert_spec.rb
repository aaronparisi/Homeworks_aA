require 'rspec'
require 'dessert'

=begin
Instructions: implement all of the pending specs (the `it` statements without blocks)! Be sure to look over the solutions when you're done.
=end

describe Dessert do
  let(:chef) { double("chef") }
  subject(:brownies) { Dessert.new("Brownies", 10, chef)}

  describe "#initialize" do
    #subject(:brownies) {Dessert.new("Brownies", 10, chef)}
    it "sets a type" do
      expect(brownies.type).to eq("Brownies")
    end

    it "sets a quantity" do
      expect(brownies.quantity).to eq(10)
    end

    it "starts ingredients as an empty array" do
      expect(brownies.ingredients).to be_empty
    end

    it "raises an argument error when given a non-integer quantity" do
      expect do
        Dessert.new("fake", "ten", chef)
      end.to raise_error(ArgumentError)
    end
  end

  describe "#add_ingredient" do
    it "adds an ingredient to the ingredients array" do
      brownies.add_ingredient("Flour")

      expect(brownies.ingredients).to include("Flour")
    end
  end

  describe "#mix!" do
    it "shuffles the ingredient array" do
      brownies.add_ingredient("Eggs")
      brownies.add_ingredient("Cocoa powder")
      brownies.add_ingredient("weed butter")

      # expect(brownies.ingredients).to match_array(["Eggs", "Cocoa powder", "weed butter"])
      # expect(brownies.ingredients).to_not eq(["Eggs", "Cocoa powder", "weed butter"])
      expect(brownies.ingredients).to receive(:shuffle!)

      brownies.mix!
    end

  end

  describe "#eat" do
    it "subtracts an amount from the quantity" do
      brownies.eat(5)

      expect(brownies.quantity).to eq(5)
    end

    it "raises an error if the amount is greater than the quantity" do
      expect do
        (brownies.eat(15))
      end.to raise_error("not enough left!")
    end
  end

  describe "#serve" do
    it "contains the titleized version of the chef's name" do
      expect(chef).to receive(:titleize)

      brownies.serve
    end
  end

  describe "#make_more" do
    it "calls bake on the dessert's chef with the dessert passed in" do
      expect(chef).to receive(:bake).with(brownies)

      brownies.make_more
    end
  end
end
