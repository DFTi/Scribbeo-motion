class CommentCell < UITableViewCell
  attr_reader :comment
  Tags(avatar:30, body:31, name:32, date:33)

  def setSelected(selected, animated:animated)
    self.layer.borderColor = UIColor.yellowColor.CGColor
    self.layer.borderWidth = (selected ? 2 : 0).to_f
  end

  def comment=(c)
    @comment = c
    avatar.setImageWithURL(c.gravatar.nsurl)
    body.setText c.body
    name.setText c.name
    date.setText c.when
  end
end