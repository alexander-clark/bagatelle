# Bagatelle

Bagatelle is a very simple ORM following the data mapper pattern. It makes it easy to query a relational database and map the results into an object graph of POROs. Here's an example:

```ruby
class UserMapper < Bagatelle::Mapper
  children :pages, lists: :items
  def find(id)
    recursive_map('users', 'id', [id], associations)
  end
end

um = UserMapper.new(storage)
user = um.find(1)
#=> [#<User id=1, name="Sam", pages=[#<Page id=1, user_id=1, name="Home", body="This is my home page">], lists=[#<List id=1, user_id=1, name="To Do", items=[#<Item id=1, list_id=1, name="Mow Lawn">]>]>]
```

No ActiveRecord necessary!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bagatelle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bagatelle

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bagatelle/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
