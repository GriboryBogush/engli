# frozen_string_literal: true

# Examples can be created, destroyed and voted on, belonging to a phrase
class ExamplesController < ApplicationController
  # Set phrase/example where it's needed
  before_action :init_phrase!, only: %i[create destroy vote]
  before_action :init_example!, only: %i[destroy vote]
  before_action :authorship_filter, only: :destroy

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
    else
      flash[:danger] = @example.errors.full_messages.to_sentence
    end
    # redirect :back doesn't really seem to work (
    redirect_to phrase_path(@phrase)
  end

  # Allow users to vote for examples
  def vote
    shared_vote(params[:vote], @example, current_user)
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
    @example = @phrase.examples.find(params[:id])
  end

  # should disallow changing other user's phrases
  def authorship_filter
    unless helpers.can_delete_example? @example
      flash[:danger] = 'You are not author of the phrase or example!'
      redirect_to root_path
    end
  end
end
