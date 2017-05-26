require "voltaire/version"

module Voltaire
  def voltaire_up(amount, reputation, user)
    amount.times.collect do
      User.increment_counter(reputation, user)
    end
  end
  
  def voltaire_down(amount, reputation, user)
    amount.times.collect do
      User.decrement_counter(reputation, user)
    end
  end
  
  def voltaire_up_other(amount, reputation, user, other)
    amount.times.collect do
      other.increment_counter(reputation, user)
    end
  end
    
  def voltaire_down_other(amount, reputation, user, other)
    amount.times.collect do
      other.decrement_counter(reputation, user)
    end
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include Voltaire
  end
end
