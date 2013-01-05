class NewCommentController < ViewController::Landscape
  include Dismissable
  
  outlet :body

  def save sender
    unless @body.has_text?
      App.alert 'You cannot make a blank comment.'
    else
      create!
    end
  end

  def create!
    comment = Comment.new(body: @body.text)
    $current_note.create_comment!(comment) do |user_feedback|
      if user_feedback[:success]
        App.alert "Note saved on server.\nA local copy will appear momentarily."
        stop_drawing!
        presentingViewController.refresh $current_comment
      else
        App.alert "Comment could not be saved.\nError:#{user_feedback[:error]}"
      end
    end
  end

  def cancel sender
    dismiss
  end
end