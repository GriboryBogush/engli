# frozen_string_literal: true

# Has a lot of common functionality used thoughout application  
class ApplicationController < ActionController::Base
  # ??
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  # Run #vote_filter for both phrase and example controllers
  before_action :vote_filter, only: [:vote]

  # shared_vote is used to implement voting functionality for
  # Phrase/Example models
  def shared_vote(vote, votable, voter)
    unless voter.voted_for? votable
      helpers.new_vote(vote, votable, voter)
    else
      if (vote == 'up' && voter.voted_up_on?(votable)) ||
         (vote == 'down' && voter.voted_down_on?(votable))
        helpers.undo_vote(vote, votable, voter)
      else
        helpers.change_vote(vote, votable, voter)
      end
    end

    # Send email to author on every 5 upvotes
    helpers.check_votes_for_email(votable) if votable.class.name == 'Phrase'
  end

  private

  # Cutstomize strong parameters for Devise to sign_in/sign_up with username
  def configure_permitted_parameters
    attributes = %i[username full_name age pro]
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  # Disallow to vote for own examples and phrases
  def vote_filter
    if params[:controller] == 'examples'
      phrase = Phrase.friendly.find(params[:phrase_id])
      invalid = phrase.examples.find(params[:id]).author? current_user
    else
      invalid = Phrase.friendly.find(params[:id]).author? current_user
    end

    if invalid
      flash[:danger] = 'You cannot vote for your own phrases/examples.'
      redirect_back(fallback_location: root_path)
    end
  end
end
