class CommentsController < ViewController::Landscape
  include Dismissable
  
  def back sender
    dismiss
  end
end