require "voltaire/version"

module Voltaire
  # FOR MORE THAN INCREMENTING BY 1
  def voltaire_up(amount, reputation, user)
    user = User.find_by(id: user.id)
    new_amount = user.reputation + amount
    user.update(reputation: new_amount)
  end
  
  def voltaire_down(amount, reputation, user)
    user = User.find_by(id: user.id)
    new_amount = user.reputation - amount
    user.update(reputation: new_amount)
  end
  
  def voltaire_up_other(amount, reputation, user, other)
    user = User.find_by(id: user.id)
    new_amount = user.reputation + amount
    other.update(reputation: new_amount)
  end
    
  def voltaire_down_other(amount, reputation, user, other)
    user = User.find_by(id: user.id)
    new_amount = user.reputation - amount
    other.update(reputation: new_amount)
  end
  
  # FOR INCREMENTING
  def voltaire_plus(amount, reputation, user)
    amount.times.collect do
      User.increment_counter(reputation, user)
    end
  end
  
  def voltaire_minus(amount, reputation, user)
    amount.times.collect do
      User.decrement_counter(reputation, user)
    end
  end
  
  def voltaire_plus_other(amount, reputation, user, other)
    amount.times.collect do
      other.increment_counter(reputation, user)
    end
  end
    
  def voltaire_minus_other(amount, reputation, user, other)
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
