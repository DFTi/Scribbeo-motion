class CommentsController < ViewController::Landscape
  include Dismissable

  outlet :note_image
  outlet :note_text
  outlet :note_timecode
  outlet :note_date
  outlet :note_author

  outlet :comments_table
  
  def viewDidLoad
    @note_image.setImageWithURL($current_note.image_url, placeholderImage:Note.colorbars)
    @note_text.setText($current_note.note)
    @note_date.setText($current_note.when)
    @note_author.setText($current_note.author_name)
    @note_timecode.setText($current_note.timecode)
    @comments_table.dataSource = $current_note.comments
    @comments_table.reloadData
    super
  end

  def refresh sender
    p "#{self.class}#refresh pending https://github.com/keyvanfatehi/caps/issues/118"
  end

  def new_comment sender
    p "#{self.class}#new_comment pending"
  end

  def reply sender
    #comment = sender.superview.superview.comment
    #comment.reply
    p "#{self.class}#reply pending"
  end

  def prepareForSegue(segue, sender:sender)
    $current_comment = sender.superview.superview.comment
  end

  def back sender
    dismiss
  end
end