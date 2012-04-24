# Modularity::Rails [![Build Status](https://secure.travis-ci.org/kevgo/modularity-rails.png)](http://travis-ci.org/#!/kevgo/modularity-rails)

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

## Mixins

Similar to Ruby mixins, mixins in Modularity allow to include orthogonal functional aspects defined in separate objects into a class.
```coffeescript

myMixin =

  # This will be called when an instance of a class that includes this mixin is created.
  constructor: ->

  # This method will be available in every class that includes 
  myMethod: ->


class MyModule extends Module

  @mixin myMixin

  constructor: (container) ->
    
    # The super constructor will call the mixin constructors here.
    super

    # ...

```


# Development

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Running the unit tests

```bash
$ evergreen run
```
