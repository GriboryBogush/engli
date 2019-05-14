
module SharedMethods
  include ActiveSupport::Concern

  # Check if a given user is author of phrase/example
  def author?(user)
    self.user == user
  end

  # Depending if it's example or phrase, set carma accordingly
  # NOTE Maybe create constants for these ?
  def set_carma(vote, current_user)
    change_carma(vote, current_user, { ex_up: 2, ex_down: -1, ph_up: 4, ph_down: -2, usr: 1 })
  end

  def redo_carma(vote, current_user)
    change_carma(vote, current_user, { ex_up: 3, ex_down: -3, ph_up: 6, ph_down: -6, usr: 0 })
  end

  def unset_carma(vote, current_user)
    change_carma(vote, current_user, { ex_up: -2, ex_down: 1, ph_up: -4, ph_down: 2, usr: -1 })
  end

  private
  
  #Implementation method for carma
  def change_carma(vote, current_user, vals)
    author_carma = self.user.carma
    author = self.user

    if self.class.name == 'Example'
      author_carma += vote == 'up' ? vals[:ex_up] : vals[:ex_down]
    else #Phrase
      author_carma += vote == 'up' ? vals[:ph_up] :vals[:ph_down]
    end

    author.update_attribute('carma', author_carma)

    current_user.update_attribute('carma', current_user.carma + vals[:usr]) if vals[:usr] != 0
  end

end
