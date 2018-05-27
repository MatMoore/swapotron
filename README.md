# Swapotron

Swapotron is a gem for reallocating stuff based on preferences.

It uses the [Top Trading Cycle](https://en.wikipedia.org/wiki/Top_trading_cycle)
algorithm to generate a stable allocation of resources, which means that:
- there are no further swaps that would make both sides happier
- nothing can be gained by misrepresenting your preferences

## Installation
**NOTE: this is not published to RubyGems yet.**

Add this line to your application's Gemfile:

```ruby
gem 'swapotron'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install swapotron

## Usage

Initialise the swapper with a hash:

```ruby
# Alice owns item 1, Bob owns item 2, Carol owns item 3
swapper = Swapotron::Swapper.new(alice: 1, bob: 2, carol: 3)
```

If a person isn't happy with the thing they have, set their preferred items:

```ruby
swapper.set_preferences(:alice, [2, 3])
swapper.set_preferences(:bob, [1, 3])
swapper.set_preferences(:carol, [2, 1])
```

Call `#proposed_swaps` at any time to get possible swaps that are in line with the preferences.

```ruby
swapper.proposed_swaps
=> [[:bob, :alice]]
```

Call `#swap` with an array of people to swap their items:

```ruby
# Alice and Bob's preferences will be cleared.
swapper.swap([:alice, :bob])
=> {:alice=>2, :bob=>1, :carol=>3}

# There are no more proposed swaps because nobody wants to swap with Carol
swapper.proposed_swaps
=> []
```

Swapping items clears all preferences related to the swap, so even if the swap was not a recommended one, Swapotron will not suggest further swaps that undo it.

If the array is more than two items, the items get rotated between people:

```ruby
swapper.swap([:alice, :bob, :carol])
=> {:alice=>1, :bob=>3, :carol=>2}
```

Calling `#swap_all` will automatically swap items until no more swaps are proposed.

```ruby
swapper = Swapotron::Swapper.new(alice: 1, bob: 2, carol: 3)
swapper.set_preferences(:alice, [2, 3])
swapper.set_preferences(:bob, [1, 3])
swapper.set_preferences(:carol, [2, 1])
swapper.swap_all
=> {:alice=>2, :bob=>1, :carol=>3}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
