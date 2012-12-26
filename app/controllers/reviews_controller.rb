class ReviewsController < ViewController::Landscape
  include Dismissable
  
  def back sender
    dismiss
  end
end