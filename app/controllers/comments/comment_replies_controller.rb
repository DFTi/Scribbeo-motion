class CommentRepliesController < ViewController::Landscape
  
  outlet :name
  outlet :date
  outlet :avatar
  outlet :body
  outlet :replies_table
  
  def viewDidLoad
    @name.setText $current_comment.name
    @date.setText $current_comment.when
    @body.setText $current_comment.body
    @avatar.setImageWithURL $current_comment.gravatar.nsurl
    @replies_table.dataSource = $current_comment.replies
    super
  end

  def viewDidAppear animated
    @replies_table.reloadData
  end

  def refresh sender
    presentingViewController.refresh $current_comment
  end

  def return_to_viewer sender
    dismiss_from $viewer
  end

  def prepareForSegue(segue, sender:sender)
    unless sender.titleLabel.text == 'New Reply'
      $previous_comment = $current_comment
      $current_comment = sender.superview.superview.comment
    end
  end

  def back sender
    $current_comment = $previous_comment
    dismiss
  end
end