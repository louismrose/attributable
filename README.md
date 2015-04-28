# Attributable [![Build Status](https://travis-ci.org/mutiny/attributable.png)](https://travis-ci.org/mutiny/attributable) [![Code Climate](https://codeclimate.com/github/mutiny/attributable.png)](https://codeclimate.com/github/mutiny/attributable) [![Dependency Status](https://gemnasium.com/mutiny/attributable.png)](https://gemnasium.com/mutiny/attributable) [![Test Coverage](https://codeclimate.com/github/mutiny/attributable/badges/coverage.svg)](https://codeclimate.com/github/mutiny/attributable)

A tiny library that makes it easy to create value objects.

## Basic usage

```ruby
require "attributable"

class User
  extend Attributable

  attributes :forename, :surname
end

john = User.new(forename: "John", surname: "Doe")
john.forename # => "John"
john.surname  # => "Doe"
```

All attributes are read-only:

```ruby
john.forename = "Jonathan" # => NoMethodError: undefined method `forename='
```

Default values for attributes can be set via a hash argument to `attributes`:

```ruby
class UserWithDefaults
  extend Attributable

  attributes :forename, :surname, active: true
end

anon = UserWithDefaults.new
anon.active   # => true
anon.forename # => nil
```

### Equality

Attributable adds `eql?` and `==` methods to your class which compare attribute values and types.

```ruby
john = User.new(forename: "John", surname: "Doe")
second_john = User.new(forename: "John", surname: "Doe")

john.eql? second_john # => true
john == second_john   # => true
```
  
The equality methods return false when compared to an object of the same type with different attribute values:

```ruby
jane = User.new(forename: "Jane", surname: "Doe")
john.eql? jane # => false
john == jane   # => false
```
  
The equality methods return false when compared to an object of a different type, even if the attribute values are equal.

```ruby
class Admin
  extend Attributable

  attributes :forename, :surname
end

admin_john = Admin.new(forename: "Jane", surname: "Doe")
john.eql? admin_john # => false
john == admin_john   # => false
```

Because Attributable overrides `eql?` and `==`, it also overrides `hash`:

```ruby
john.hash == second_john.hash # => true
john.hash == jane.hash        # => false
john.hash == admin_john.hash  # => false
```

### Pretty printing

Attributable adds an `inspect` method to your class which display attribute values.

```ruby
john.inspect # => <User forename="John", surname="Doe">
```

### Using with custom initialisation logic

Attributable provides the `initialize_attributes` method which can be used if you need to specify your own `initialize` method. For example:

```ruby
class UserWithDerivedAttribute
  extend Attributable
  attributes :forename, :surname
  
  attr_accessor :fullname
  
  def initialize(attributes = {})
    initialize_attributes(attributes)
    @fullname = "#{forename} #{surname}"
  end
end

john = UserWithDerivedAttribute.new(forename: "John", surname: "Doe")
john.forename # => "John"
john.fullname # => "John Doe"
```

Note that, by default, Attributable adds the following `initialize` method:

```ruby
def initialize(attributes = {})
  initialize_attributes(attributes)
end
```

### Reuse via inheritance and mix-ins

To reuse attribute declarations, either user Ruby's built-in inheritance, mix-ins, or both:

```ruby
class Author < User
  attributes blogs: []
end

ronson = Author.new(forename: "Jon", surname: "Ronson")
ronson.inspect # => <Author forename="Jon", surname="Ronson", blogs=[]>
```
    
The default values defined in superclasses or mixed-in modules can be changed:

```ruby
class Ronson < User
  attributes surname: "Ronson"
end

Ronson.new(forename: "Jon").inspect # <Ronson forename="Jon", surname="Ronson">
Ronson.new(forename: "Mark").inspect # <Ronson forename="Mark", surname="Ronson">
```

Here's the same example, but using a module:

```ruby
module User
  extend Attributable

  attributes :forename, :surname
end

class Author
  include User
  extend Attributable
  attributes blogs: []
end

ronson = Author.new(forename: "Jon", surname: "Ronson")
ronson.inspect # => <Author forename="Jon", surname="Ronson", blogs=[]>

class Ronson
  include User
  extend Attributable
  attributes surname: "Ronson"
end

Ronson.new(forename: "Jon").inspect # <Ronson forename="Jon", surname="Ronson">
Ronson.new(forename: "Mark").inspect # <Ronson forename="Mark", surname="Ronson">
```
    
__Note__: the `include` must occur before any call to `attributes`.

## Installation

Add this line to your application's Gemfile:

    gem 'attributable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attributable

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
