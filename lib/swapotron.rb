require "swapotron/version"
require 'rgl/adjacency'

module Swapotron
  class Swapper
    def initialize(initial_allocation)
      @current_allocation = initial_allocation
      @rankings = {}
    end

    def set_preferences(entity, things)
      raise ArgumentError.new("No initial allocation for #{entity.inspect}") unless current_allocation.include?(entity)
      raise ArgumentError.new("#{current_allocation[entity]} is already allocated to #{entity}.") if things.include?(current_allocation[entity])
      unknown = things - current_allocation.values
      raise ArgumentError.new("Unswappable things: #{unknown.join(', ')}") unless unknown.empty?

      rankings[entity] = things
    end

    def proposed_swaps
      top_preference_graph.cycles
    end

    def swap(cycle)
      raise ArgumentError.new("Argument should be a list of 2 or more entities") if cycle.length < 2

      values = cycle.map { |entity| current_allocation[entity] }
      next_values = values.drop(1) + values.take(1)
      replacements = cycle.zip(next_values).to_h

      # These are happy for now, so remove their preferences
      cycle.each do |entity|
        rankings.delete(entity)
      end

      current_allocation.merge!(replacements)
    end

    def swap_all
      loop do
        remaining_swaps = proposed_swaps
        return current_allocation if remaining_swaps.empty?

        swap(remaining_swaps.first)
      end

      current_allocation
    end

  private

    attr_reader :current_allocation
    attr_reader :rankings

    def top_preferences
      remaining_things = rankings.keys.map {|entity| current_allocation[entity]}

      rankings.map do |entity, thing|
        [entity, rankings[entity].find {|thing| remaining_things.include?(thing)}]
      end
    end

    def top_preference_graph
      graph = RGL::DirectedAdjacencyGraph.new

      top_preferences.each do |entity, preferred|
        current_owner = current_allocation.key(preferred)
        graph.add_edge(entity, current_owner)
      end

      graph
    end
  end
end
