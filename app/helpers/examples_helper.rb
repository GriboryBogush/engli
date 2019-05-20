# Used to check authorship when needed
module ExamplesHelper
  def can_delete_example?(example)
    example.author?(current_user) || example.phrase.author?(current_user)
  end
end
