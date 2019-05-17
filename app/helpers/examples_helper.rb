# Only used by view to display or not display delete action link
module ExamplesHelper
  def show_example_delete_link?(example)
    example.author?(current_user) || example.phrase.author?(current_user)
  end
end
