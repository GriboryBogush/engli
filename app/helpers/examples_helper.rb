module ExamplesHelper

  def show_example_delete_link?(example)
    example.author?(current_user) || example.phrase.author?(current_user)
  end

end
