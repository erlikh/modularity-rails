# Modularity::Rails [![Build Status](https://secure.travis-ci.org/kevgo/modularity-rails.png)](http://travis-ci.org/#!/kevgo/modularity-rails)

Makes the [Modularity CoffeeScript](http://github.com/kevgo/modularity-coffeescript) library and related modules available to
Rails 3.1 applications.

Modularity is a framework for lightweight component-oriented CoffeeScript.
It allows to compose functionally rich web pages in a clean, intuitive, and testable way
out of well structured and reusable components. It scales very well with complexity.


## Authors
* [Kevin Goslar](https://github.com/kevgo) (kevin.goslar@gmail.com)
* [Alex David](https://github.com/alexdavid)


# Installation

Load modularity in your application's Gemfile:
                         
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


## Modules

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

## Hooks

Hooks are a more direct and easier way to interact with mixins. They are methods with predefined names that mixing modules can implement to hook into events of their mixins
without the need to wire up event handlers, and with the ability to interact with the workflow of the mixins.


# Reusable example modules and mixins.

Modularity comes bundled with a bunch of example modules and mixins that can be used in production code.
The example modules are located in `vendor/assets/javascripts/modules/` and _vendor/assets/javascripts/mixins_
and must be explicitly required in your Rails files using the `require` commands of the asset pipeline.


## Modules

* __button.coffee__: A simple button. Fires the `clicked` event when anything inside the container is clicked. Uses the `clickable` mixin.  
* __counter_button.coffee__: Similar to button, but includes the click count as data payload in the fired event.


## Mixins

###clickable
Including this mixins adds a 'clickable' aspect to your module, i.e. turns it into a button. Clicking anywhere inside the container makes it fire the 'clicked' event.

###closable
Including this mixin makes a module closable. The mixin searches for an embedded DOM element with the class 'CloseButton'. When it is clicked, the following things happen:

* The _closable_closing_ hook of the closable class is called.
  This hook could be used to display confirmation dialogs (and abort the close process) or to fire custom events that depend on the DOM still being present. 
  If this method returns a falsy value, the closing process is aborted.
* The closable module fires a local 'closing' event (with the DOM still present).
* The whole module including its container is removed from the DOM.
* The _closable_closed_ hook of the closable class is called.


## Tools

### Loader
A generic cached loader for parallel and repeated GET requests.
Prevents duplicate requests, caches the responses.

The first request triggers the ajax request. Subsequent requests while the resquest is running are accumulated without causing new requests.
Once the response arrives, all currently requesting clients are answered. Subsequent requests are answered immediately using the cached data.  

```coffeescript
Module.loader.get '/test.json', (data) ->
  # Use data here.
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

Modularity-Rails comes with support for [LifeReload](https://github.com/mockko/livereload) via [Guard](https://github.com/guard/guard).

* Install the LiveReload browser extension: [Chrome](https://chrome.google.com/webstore/detail/jnihajbhpnppcggbcgedagnkighmdlei)
* Run the evergreen server: ```$ evergreen run```
* Run the guard server: ``` $ bundle exec guard ```
* Start the LiveReload plugin in Chrome (button in address bar).
* Navigate to the test page that you want to observe.
* Change and save code and see the browser reload.

