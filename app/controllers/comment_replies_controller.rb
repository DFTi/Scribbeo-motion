class CommentRepliesController < ViewController::Landscape
  include Dismissable

  outlet :replies_table
  
  def viewDidLoad
    @replies_table.dataSource = $current_comment.replies
    @replies_table.reloadData
    super
  end

  def prepareForSegue(segue, sender:sender)
    $previous_comment = $current_comment
    $current_comment = sender.superview.superview.comment
  end

  def back sender
    $current_comment = $previous_comment
    dismiss
  end
end