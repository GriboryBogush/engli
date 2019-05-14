
class ExamplesController < ApplicationController

  # Set phrase/example where it's needed
  before_action :init_phrase!, only: [:create, :destroy, :vote]
  before_action :init_example!, only: [:destroy, :vote]
  before_action :authorship_filter, only: [:destroy]


  def create
    @example = @phrase.examples.new(example_params)
    if @example.save
      flash[:notice] = 'Example has been created!'
    else
      flash[:danger] = @example.errors.full_messages.to_sentence
    end
    redirect_to phrase_path(@phrase)

  end

  def destroy
    if @example.destroy
      flash[:notice] = 'Example has been deleted!'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = @example.errors.full_messages.to_sentence
    end
  end

  # Allow users to vote for examples
  def vote
    shared_vote(@example, params[:vote], current_user)
    redirect_back(fallback_location: root_path)
  end

  private
  def example_params
    params.require(:example).permit(:example, :user_id)
  end

  def init_phrase!
    @phrase = Phrase.friendly.find(params[:phrase_id])
  end

  def init_example!
    @example = @phrase.examples.find(params[:example_id])
  end

  # should disallow changing other user's phrases
  def authorship_filter
    @phrase = Phrase.friendly.find(params[:phrase_id])
    @example = @phrase.examples.find(params[:id])
    unless (@example.user  == current_user || @phrase.author?(current_user))
      flash[:danger] = 'You are not author of the phrase/example!'
      redirect_back(fallback_location: root_path)
      return false
    end
    true
  end

end
