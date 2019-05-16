# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # ??
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  # Run #vote_filter for both phrase and example controllers
  before_action :vote_filter, only: [:vote]

  # shared_vote is used to implement voting functionality for
  # Phrase/Example models
  # FIXME: refractor the method
  def shared_vote(votable, vote, user)
    # lambda for common functionality
    up_or_down = ->(vote) { vote == 'up' ? votable.upvote_by(user) : votable.downvote_by(user) }

    if user.voted_for? votable
      if (vote == 'up' && user.voted_up_on?(votable)) || (vote == 'down' && user.voted_down_on?(votable))

        # Undo vote. Subtract carma
        votable.unvote_by user
        votable.unset_carma(vote, user)
        flash[:notice] = 'You\'ve undone your vote.'
      else

        # Change vote. Change carma
        up_or_down.call(vote)
        votable.redo_carma(vote, user)
        flash[:notice] = 'You\'ve changed your vote.'
      end
    else

      # New vote. Add +4 carma to author, +1 to author
      up_or_down.call(vote)
      votable.set_carma(vote, user)
      flash[:notice] = 'Thank you for your vote.'
    end

    # Send email to author on every 5 upvotes
    if votable.class.name == 'Phrase' && votable.weighted_score % 5 == 0 && votable.weighted_score / 5 > 0
      ApplicationMailer.with(user: votable.user, phrase: votable).notify_five_upvotes.deliver_later
    end
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
      invalid = phrase.examples.find(params[:example_id]).user == current_user
    else
      invalid = Phrase.friendly.find(params[:id]).user == current_user
    end

    if invalid
      flash[:danger] = 'You cannot vote for your own phrases/examples.'
      redirect_back(fallback_location: root_path)
    end
  end
end
