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

  def note=(note)
    viewWithTag(NoteCell::Tags::IMAGE).setImageWithURL(note.image_url, placeholderImage:note.placeholder_image)
    viewWithTag(NoteCell::Tags::AUTHOR).setText(note.author_name)
    viewWithTag(NoteCell::Tags::TIMECODE).setText(note.timecode)
  end
end