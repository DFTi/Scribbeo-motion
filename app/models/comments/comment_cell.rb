class CommentCell < UITableViewCell
  attr_accessor :id

  module Tags
    EXPAND_LABEL = 33
    EXPAND_TOGGLE = 30
    TEXT_FIELD = 31 
    CLIP_VIEW_IMAGE = 32
  end
end