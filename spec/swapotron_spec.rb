require "spec_helper"

RSpec.describe Swapotron do
  it "has a version number" do
    expect(Swapotron::VERSION).not_to be nil
  end
end

RSpec.describe Swapotron::PreferenceGraph do
  it "identifies cycles of length 2" do
    allocation = {
      "Alice" => 1,
      "Bob" => 2,
      "Carol" => 3,
      "Dave" => 4
    }
    preference = {
      "Alice" => 2,
      "Bob" => 1,
      "Carol" => 4,
      "Dave" => 3
    }
    graph = Swapotron::PreferenceGraph.new(allocation, preference)
    expect(graph.cycles).to eq(
      [
        ["Bob", "Alice"],
        ["Dave", "Carol"],
      ]
    )
  end

  it "identifies cycles of length 3" do
    allocation = {
      "Alice" => 1,
      "Bob" => 2,
      "Carol" => 3,
    }
    preference = {
      "Alice" => 2,
      "Bob" => 3,
      "Carol" => 1
    }
    graph = Swapotron::PreferenceGraph.new(allocation, preference)
    expect(graph.cycles).to eq(
      [
        ["Bob", "Carol", "Alice"],
      ]
    )
  end

  it "identifies cycles of length 1" do
    allocation = {
      "Alice" => 1,
      "Bob" => 2,
      "Carol" => 3,
    }
    preference = {
      "Alice" => 2,
      "Bob" => 3,
      "Carol" => 3
    }
    graph = Swapotron::PreferenceGraph.new(allocation, preference)
    expect(graph.cycles).to eq(
      [
        ["Carol"],
      ]
    )
  end
end
