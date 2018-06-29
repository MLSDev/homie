require "homie/version"

module Homie
  class ObserverNotPassedError < StandardError
    MSG = 'You should pass at least one or more objects with method call OR block.'

    def message; MSG end;
  end

  class EventNotSpecifiedError < StandardError
    MSG = 'You should specify event name.'

    def message; MSG end;
  end

  def on(event, *objects, &block)
    raise(Homie::EventNotSpecifiedError) unless event && !event.empty?

    raise(Homie::ObserverNotPassedError) unless objects.all? { |object|  object.respond_to?(:call) }

    raise(Homie::ObserverNotPassedError) if (_observers = [*objects, block].compact).size == 0

    observers[event] += _observers

    self
  end

  def broadcast(event, *args)
    observers[event].each { |observer| observer.call(*args) }

    self
  end

  def succeeded(*args)
    broadcast(:succeeded, *args)
  end

  def failed(*args)
    broadcast(:failed, *args)
  end

  private

  def observers
    @observers ||= Hash.new { |hash, event| hash[event] = [] }
  end
end

