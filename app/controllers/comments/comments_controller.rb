class CommentsController < ViewController::Landscape

  outlet :note_image
  outlet :note_text
  outlet :note_timecode
  outlet :note_date
  outlet :note_author

  outlet :comments_table

  def viewDidLoad
    load_data
    super
  end

  def load_data
    @note_image.setImageWithURL($current_note.image_url, placeholderImage:Note.colorbars)
    @note_text.setText($current_note.note)
    @note_date.setText($current_note.when)
    @note_author.setText($current_note.author_name)
    @note_timecode.setText($current_note.timecode)
    @comments_table.dataSource = $current_note.comments
  end

  def viewDidAppear animated
    $current_comment = nil
    $previous_comment = nil
    @comments_table.reloadData
  end

  def refresh sender
    $current_note.refresh! do
      load_data
      dismiss_from(self) if sender.is_a? Comment
    end
  end

  def prepareForSegue(segue, sender:sender)
    unless sender.titleLabel.text == 'New Comment'
      $current_comment = sender.superview.superview.comment
    end
  end

  def back sender
    dismiss
  end
end