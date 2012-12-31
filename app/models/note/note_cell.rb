class NoteCell < UITableViewCell
  module Tags
    IMAGE = 1
    AUTHOR = 2
    TIMECODE = 3
  end
  def setSelected(selected, animated:animated)
    self.layer.borderColor = UIColor.yellowColor.CGColor
    self.layer.borderWidth = (selected ? 2 : 0).to_f
  end

  def image
    viewWithTag(NoteCell::Tags::IMAGE)
  end

  def author
    viewWithTag(NoteCell::Tags::AUTHOR)
  end

  def timecode
    viewWithTag(NoteCell::Tags::TIMECODE)
  end

  def note=(note)
    image.setImageWithURL(note.image_url, placeholderImage:Note.colorbars)
    author.setText(note.author_name)
    timecode.setText(note.timecode)
  end
end