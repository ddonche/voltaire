require "voltaire/version"

module Voltaire
  # FOR MORE THAN INCREMENTING BY 1
  def voltaire_up(amount, reputation, user)
    get_user = User.find_by(id: user)
    get_user.reputation += amount
    get_user.save
  end
  
  def voltaire_down(amount, reputation, user)
    get_user = User.find_by(id: user)
    get_user.reputation -= amount
    get_user.save
  end
  
  def voltaire_up_other(amount, reputation, user, other)
    get_other = other.find_by(id: user)
    get_other.reputation += amount
    get_other.save
  end
    
  def voltaire_down_other(amount, reputation, user, other)
    get_other = other.find_by(id: user)
    get_other.reputation -= amount
    get_other.save      
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
