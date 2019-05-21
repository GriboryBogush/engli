# frozen_string_literal: true

# Phrases can be shown, created, edited, deleted and voted on
class PhrasesController < ApplicationController
  # set phrase for every action that needs it
  before_action :init_phrase, only: %i[show edit update destroy vote]
  before_action :authorship_filter, only: %i[edit update destroy]

  def index
    # Paginate phrases
    @phrases = Phrase.paginate(page: params[:page])
  end

  def show
    # Paginate examples of a phrase
    @examples = @phrase.examples.paginate(page: params[:page])
    @example = @phrase.examples.build(user_id: current_user.id)
  end

  def new
    @phrase = Phrase.new
    @phrase.examples.build(user_id: current_user.id)
  end

  def create
    @phrase = current_user.phrases.new(phrase_params)
    if @phrase.save
      flash[:notice] = 'Phrase has been created'
      redirect_to root_path
    else
      flash.now[:danger] = @phrase.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit; end

  def update
    if @phrase.update(phrase_params)
      flash[:notice] = 'Phrase has been updated'
      redirect_to user_path(@phrase.user)
    else
      flash.now[:danger] = @phrase.errors.full_messages.to_sentence
      render :edit
    end
  end

  # SUGGESTION: make sure PublicActivity record gets deleted too?
  def destroy
    if @phrase.destroy
      flash[:notice] = 'Phrase has been deleted'
      redirect_to user_path(@phrase.user)
    else
      flash[:danger] = @phrase.errors.full_messages.to_sentence
    end
  end

  # Allow users to vote for phrases
  def vote
    shared_vote(params[:vote], @phrase, current_user)
    redirect_back(fallback_location: root_path)
  end

  private

  def phrase_params
    valid_params = params.require(:phrase).permit(
          :phrase, :translation, :category,
          examples_attributes: %i[example user_id _destroy])
    # convert category number from string to int due to select element ??
    valid_params[:category] = valid_params[:category].to_i
    valid_params
  end

  def init_phrase
    @phrase = Phrase.friendly.find(params[:id])
  end

  # should disallow changing other user's phrases
  def authorship_filter
    unless helpers.can_delete_phrase? @phrase
      flash[:danger] = 'You are not author of the phrase!'
      redirect_to root_path
    end
  end
end
