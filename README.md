# Modularity::Rails

Makes the [Modularity CoffeeScript](http://github.com/kevgo/modularity-coffeescript) library available to 
Rails 3.1 applications. 


## Installation

Add this line to your application's Gemfile:
                         
```ruby
gem 'modularity-rails'
```

And then execute:

```bash
$ bundle
```

Finally, you have to load the modularity file into your application's javascript.
The easiest way is to add it to `application.js`:

```javascript
/**                   
 *= require jquery
 *= require modularity
 */
```


## Usage

See [http://github.com/kevgo/modularity-coffeescript].


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
