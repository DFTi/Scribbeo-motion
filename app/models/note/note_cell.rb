class NoteCell < UITableViewCell
  Tags(image:1, author:2, timecode:3)
  
  def setSelected(selected, animated:animated)
    self.layer.borderColor = UIColor.yellowColor.CGColor
    self.layer.borderWidth = (selected ? 2 : 0).to_f
  end
  
  def note=(note)
    image.setImageWithURL(note.image_url, placeholderImage:Note.colorbars)
    author.setText(note.author_name)
    timecode.setText(note.timecode)
  end
end