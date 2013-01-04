class CommentRepliesController < ViewController::Landscape
  include Dismissable
  
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
    @replies_table.reloadData
    super
  end

  def refresh sender
    p "#{self.class}#refresh pending https://github.com/keyvanfatehi/caps/issues/118"
  end

  def return_to_viewer sender
    dismiss_from $viewer
  end

  def new_reply sender
    presentingViewController.new_comment self
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