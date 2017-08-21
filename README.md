# Rack::TradeTracker

The `Rack::TradeTracker` gem is for use with the Trade Tracker affiliate network.

The gem provides a [Rack middleware](http://guides.rubyonrails.org/rails_on_rack.html) component to handle Trade Tracker's redirect mechanism.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-trade_tracker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-trade_tracker

## Usage

Note that `domain:` and `path:` are required options and you will get an error if you don't provide these:
- Replace `'your-domain'` with your domain name minus `www`; e.g. `clickmechanic.com`.
- Replace `'your-path'` with the target path you have agreed with Trade Tracker; e.g. `/repair` (note the leading `/`)

> The gem makes no assumptions about where and how you implement the Trade Tracker JS script.  You will need to do this yourself.

### `config.ru`
If you are running a basic Rack app, you can configure the middleware in your `config.ru` file:
```ruby
use Rack::TradeTracker, domain: 'your-domain', path: '/your_path'
```

### Rails
If you are using Rails, you can configure the rack middleware in `config/application.rb`, or one of the `config/environments/<environment>.rb` files, using one of the provided helper methods:
```Ruby
config.middleware.use('Rack::TradeTracker', domain: 'your-domain', path: 'your-path')

# or
config.middleware.insert_before(existing_middleware, 'Rack::TradeTracker', domain: 'your-domain', path: 'your-path')

# or
config.middleware.insert_after(existing_middleware, 'Rack::TradeTracker', domain: 'your-domain', path: 'your-path')
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rack-trade_tracker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rack::TradeTracker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rack-trade_tracker/blob/master/CODE_OF_CONDUCT.md).
