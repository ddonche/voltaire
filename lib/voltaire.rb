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
  
end
