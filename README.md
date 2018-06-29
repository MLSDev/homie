# Homie

Welcome!

Those of you who know why and when we need the Observer pattern  will definitely find this gem useful. Those of you who don't, should read about the Observer pattern and return here afterward.

Ruby has a default module called Observable that reflect same idea but doesn't have such flexibility as Homie. 

Homie will do the dirty work for you. It will call and execute all required logic sequentially. All you need is to:

- consider Homie syntax
- decompose the logic into the `subject` and `observers` bound to particular events
- broadcast those events when they happen

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'homie'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install homie

## Usage
###About
To implement Observer pattern and start using Homie first you should decompose logic into 2 object types:
* `Subject` - the main part of logic, depending on the results of which the further part of logic should vary between scenarios.
* `Observer` - those scenarios that will be executed depending on the Subject result.

###Include into your `Subject` Homie module

```ruby
  include Homie
```
###Subscribing

Bind `Observers` to your `Subject` on particular events. As an `Observer` it could be any object with a *call* method(that is an entry point for business logic) **OR** a block of code.

To bind Observer use method `on(event_name, Observer)`.

You have 2 options, how you could bind your observers:

* When you want to incapsulate those observers.
```ruby
class UserCreator
  include Homie

  def initialize(params)
    @params = params
    
    self.on(:succeeded, StatistictsGenerator.new)
    self.on(:succeeded) { |user| EmailPublisher.send_email(user) }
  end
end
```

*Your observers should repeat signature of params passing by Subject in their method call or in a block of code.*

* When incapsulation don't bother you **OR** you need to apply a closure for some context/method execution.

```ruby
class UsersController < ApplicationController
  def create
    UserCreator.new(params).
      on(:succeeded) do |user|
        render json: user, status: 201
      end.
      on(:failed) do |user|
        render json: user.errors, status: 422
      end.call
  end
end
``` 

*Subscribing supports chaining*.

###Broadcasting
To broadcast an event use method `broadcast(event_name, *arguments)`.
*Broadcasting also support chaining.*

```ruby
class UserCreator
  include Homie
  
  def initialize(params)
    @params = params
  end

  def call
    user = User.create!(@params)
    broadcast :succeeded, user 
  rescue ActiveRecord::RecordInvalid => invalid
    broadcast :failed, invalid.record
  end
end
```

*You can incapsulate broadcasting of events or make public method calls as well.*

I support the theory that says that two events are usually enough: **succeeded** or **failed**. 

I have made shortcuts for these cases. 

So 

`broadcast :succeeded, user` is equal to `succeeded(user)`

**and** 

`broadcast :failed, user` is equal to `failed(user)`.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/donasktello/homie. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

