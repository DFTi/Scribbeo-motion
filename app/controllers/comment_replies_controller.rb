class CommentRepliesController < ViewController::Landscape
  include Dismissable

  outlet :replies_table
  
  def viewDidLoad
    @replies_table.dataSource = $current_comment.replies
    @replies_table.reloadData
    super
  end

  def refresh sender
    p "#{self.class}#refresh pending https://github.com/keyvanfatehi/caps/issues/118"
  end

  def return_to_viewer sender
    dismiss_from $viewer
  end

  def reply sender
    #comment = sender.superview.superview.comment
    #comment.reply
    p "#{self.class}#reply pending"
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