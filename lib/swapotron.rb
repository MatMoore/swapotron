require "swapotron/version"
require 'rgl/adjacency'

module Swapotron
  class Swapper
    def initialize(initial_allocation)
      @current = initial_allocation
      @preferences = {}
    end

    def set_preferences(entity, things)
      raise ArgumentError("No initial allocation for #{entity.inspect}") unless initial.include?(entity)

      # check things

      preferences[entity] = things
    end

    def proposed_swaps
      PreferenceGraph.new(allocation, preferences).cycles
    end

    def swap(cycle)

    end
  end

  class PreferenceGraph
    def initialize(current_allocation, requested_allocation)
      @graph = RGL::DirectedAdjacencyGraph.new

      requested_allocation.each do |entity, preferred|
        current_owner = current_allocation.key(preferred)
        @graph.add_edge(entity, current_owner)
      end
    end

    def cycles
      graph.cycles
    end

  private

    attr_reader :graph

  end
end
