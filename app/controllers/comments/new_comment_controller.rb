class NewCommentController < ViewController::Base
  
  outlet :body

  def viewDidAppear animated
    if $current_comment
      @parent_id = $current_comment.id
    end
  end

  def save sender
    unless @body.has_text?
      App.alert 'You cannot make a blank comment.'
    else
      sender.enabled = false
      create! { sender.enabled = true }
    end
  end

  def create!(&block)
    comment = Comment.new(body: @body.text, parent_id:@parent_id)
    $current_note.create_comment!(comment) do |res|
      if res[:success]
        container << Comment.new(res[:comment])
        dismiss
      else
        App.alert "Comment could not be saved.\nError:#{user_feedback[:error]}"
      end
      block.call
    end
  end

  def container
    c = $current_comment || $current_note
    c.is_a?(Comment) ? c.replies : c.comments
  end

  def cancel sender
    dismiss
  end
end