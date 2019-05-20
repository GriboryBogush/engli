# Used to check authorship when needed
module PhrasesHelper
  def can_delete_phrase?(phrase)
    phrase.author?(current_user)
  end
end
