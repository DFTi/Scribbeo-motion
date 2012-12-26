class ReviewClipView < UIView
  def touchesBegan(touches, event)
    p "clip view touched, play ?"

  end
end

class ReviewClipImage < UIImageView
  def touchesBegan(touches, event)
    p "clip image touched, play ?"

  end
end