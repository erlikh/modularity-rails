# Modularity::Rails [![Build Status](https://secure.travis-ci.org/kevgo/modularity-rails.png)](http://travis-ci.org/#!/kevgo/modularity-rails)

Makes the [Modularity CoffeeScript](http://github.com/kevgo/modularity-coffeescript) library available to 
Rails 3.1 applications. 

Modularity is a pattern and framework for lightweight object-oriented JavaScript 
that allows to compose functionally rich web pages in a clean and testable way 
out of well structured and reusable components.


# Installation

Add this line to your application's Gemfile:
                         
```ruby
gem 'modularity-rails'
```

And then execute:

```bash
$ bundle
```

Finally, you have to load the modularity file into your application's javascript.
The easiest way is to add it to `application.coffee`:

```coffeescript
 # require jquery
 # require modularity
```


# Usage

Modularity is a lightweight framework for building powerful AJAX applications.
Modularity avoids magic and heavyness. It focusses on providing a pragmatic and interoperable foundation 
for clean hand-written code bases. 
Modularity provides practices to create code bases of incredible complexity that are still 
nicely manageable and perform very well. 


# Modules

Modules are native CoffeeScript classes that are specialized for doing what most JavaScript running in browsers does: 
managing a UI consisting of DOM elements, reacting to events that happen within that section, 
representing application logic specific to that section, and providing high-level APIs for others to interact with the section.

Each module has a container. The container is the outermost DOM element of a section. 
Everything the module does must happen inside this container. 
The module is responsible for managing the inner DOM-structure of the container.




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

## Automatically refreshing the browser during development.

* Install the LiveReload browser extension: [Chrome](https://chrome.google.com/webstore/detail/jnihajbhpnppcggbcgedagnkighmdlei)
* Run the evergreen server: ```$ evergreen run```
* Run the guard server: ``` $ bundle exec guard ```
* Start the LiveReload plugin in Chrome (button in address bar).
* Navigate to the test page that you want to observe.
* Change and save code and see the browser reload.

