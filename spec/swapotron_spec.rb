require "spec_helper"

RSpec.describe Swapotron do
  it "has a version number" do
    expect(Swapotron::VERSION).not_to be nil
  end
end

RSpec.describe Swapotron::Swapper do
  describe "#swap" do
    subject {Swapotron::Swapper.new(alice: 1, bob: 2, carol: 3)}

    it "swaps pairs around" do
      expect(subject.swap([:alice, :bob])).to eq(
        alice: 2,
        bob: 1,
        carol: 3
      )
    end

    it "swaps triples around" do
      expect(subject.swap([:alice, :bob, :carol])).to eq(
        alice: 2,
        bob: 3,
        carol: 1
      )
    end

    it "rejects an empty array" do
      expect { subject.swap([]) }.to raise_error(ArgumentError)
    end

    it "rejects a single item list" do
      expect { subject.swap([:alice]) }.to raise_error(ArgumentError)
    end
  end

  describe "#proposed_swaps" do
    subject {Swapotron::Swapper.new(alice: 1, bob: 2, carol: 3, dave: 4)}

    it "identifies cycles of length 2" do
      subject.set_preferences(:alice, [2])
      subject.set_preferences(:bob, [1])
      subject.set_preferences(:carol, [4])
      subject.set_preferences(:dave, [3])

      expect(subject.proposed_swaps).to eq(
        [
          [:bob, :alice],
          [:dave, :carol],
        ]
      )
    end

    it "identifies cycles of length 3" do
      subject.set_preferences(:alice, [2])
      subject.set_preferences(:bob, [3])
      subject.set_preferences(:carol, [1])

      expect(subject.proposed_swaps).to eq(
        [
          [:bob, :carol, :alice],
        ]
      )
    end

    it "ignores cycles of length 1" do
      expect(subject.proposed_swaps).to eq(
        []
      )
    end
  end

  describe "#swap_all" do
    subject {Swapotron::Swapper.new(alice: 1, bob: 2, carol: 3, dave: 4)}

    it "does nothing if there are no preferences" do
      expect(subject.swap_all).to eq(alice: 1, bob: 2, carol: 3, dave: 4)
    end

    it "resolves a single swap" do
      subject.set_preferences(:alice, [2])
      subject.set_preferences(:bob, [1])

      expect(subject.swap_all).to eq(alice: 2, bob: 1, carol: 3, dave: 4)
    end

    it "ignores preferences that aren't possible" do
      subject.set_preferences(:bob, [1])
      subject.set_preferences(:carol, [1, 4])
      subject.set_preferences(:dave, [1, 3])

      expect(subject.swap_all).to eq(alice: 1, bob: 2, carol: 4, dave: 3)
    end

    it "resolves first choice swaps before second choice" do
      subject.set_preferences(:alice, [3, 2, 4])
      subject.set_preferences(:bob, [4, 1, 3])
      subject.set_preferences(:carol, [4, 1, 2])
      subject.set_preferences(:dave, [3, 2, 1])

      expect(subject.swap_all).to eq(alice: 2, bob: 1, carol: 4, dave: 3)
    end
  end

end
