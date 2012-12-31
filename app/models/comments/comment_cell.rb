class CommentCell < UITableViewCell
  module Tags
    EXPAND_LABEL = 33
    EXPAND_TOGGLE = 30
    TEXT = 31 
    IMAGE = 32
  end
  
  def image
    viewWithTag(CommentCell::Tags::IMAGE)
  end

  def text
    viewWithTag(CommentCell::Tags::TEXT)
  end

  def comment=(c)
    image.setImageWithURL(c.image_url) unless c.image_url.nil?
    text.setText c.text
  end
end