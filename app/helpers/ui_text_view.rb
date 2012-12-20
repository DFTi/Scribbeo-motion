class UITextView
  def has_text?
    self.text.size > 0
  end
  def clear!
    self.text = ''
  end
end