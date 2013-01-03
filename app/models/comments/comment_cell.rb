class CommentCell < UITableViewCell
  attr_reader :comment
  
  module Tags
    AVATAR = 30
    BODY = 31 
    NAME = 32
    DATE = 33
  end

  def setSelected(selected, animated:animated)
    self.layer.borderColor = UIColor.yellowColor.CGColor
    self.layer.borderWidth = (selected ? 2 : 0).to_f
  end
  
  def avatar
    viewWithTag(CommentCell::Tags::AVATAR)
  end

  def body
    viewWithTag(CommentCell::Tags::BODY)
  end

  def name
    viewWithTag(CommentCell::Tags::NAME)
  end

  def date
    viewWithTag(CommentCell::Tags::DATE)
  end

  def comment=(c)
    @comment = c
    avatar.setImageWithURL(c.gravatar.nsurl)
    body.setText c.body
    name.setText c.name
    date.setText c.when
  end
end