require 'spec_helper'
require 'ostruct'

RSpec.describe Homie do
  subject { user_creator }

  # Subject
  let(:user_creator) { (Class.new { include Homie }).new }

  # Observers
  let(:email_sender) { (Class.new { def self.call(user); puts "Greetings, #{user.full_name}!" if user.email; end }) }
  let(:phone_sender) { (Class.new { def self.call(user); puts "Hello, #{user.full_name}!" if user.phone; end }) }

  # Result data
  let(:user) { OpenStruct.new(full_name: 'John Doe', age: 30, email: 'johndoe@xample.com', phone: '+123456789') }

  context 'Correct using' do
    context 'Passed all observers at once' do
      subject { user_creator.on(:succeeded, email_sender, phone_sender) { |user| puts "Congratulations, #{user.full_name}! All observers've finished their work!" } }

      it 'User receives all notifications' do
        expect { subject.succeeded(user) }.to output("Greetings, John Doe!\nHello, John Doe!\nCongratulations, John Doe! All observers've finished their work!\n").to_stdout
      end
    end

    context 'Chaining of observers' do
      subject { user_creator.on(:succeeded, email_sender) }

      it 'User receives all notifications' do
        expect { subject.on(:succeeded, phone_sender).succeeded(user) }.to output("Greetings, John Doe!\nHello, John Doe!\n").to_stdout
      end
    end
  end

  context 'Incorrect using' do
    context 'Not passed event' do
      it 'shows error when event was not specified' do
        expect { subject.on('', email_sender) }.to raise_error.with_message('You should specify event name.')
      end
    end

    context 'Not passed obsever' do
      it 'shows error when observer was not passed' do
        expect { subject.on(:succeeded) }.to raise_error.with_message('You should pass at least one or more objects with method call OR block.')
      end
    end

    context 'Object without method call' do
      let(:email_sender) { (Class.new { def self.execute(user); puts "Greetings, #{user.full_name}!" if user.email; end }) }

      it 'shows error when observer has not method call' do
        expect { subject.on(:succeeded, email_sender) }.to raise_error.with_message('You should pass at least one or more objects with method call OR block.')
      end
    end
  end
end
