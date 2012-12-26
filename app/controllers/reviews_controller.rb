class ReviewsController < ViewController::Landscape
  include Dismissable

  outlet :reviews_table

  def viewDidLoad
    $reviews_controller = self
    reviews.fetch_reviews! do
      @reviews_table.dataSource = $source.reviews
      @reviews_table.reloadData
    end
  end

  def reviews
    $source.reviews
  end

  # def touchesBegan(touches, event)
  #   touch = touches.anyObject
  #   p "reviews controller got touches on #{touch.view.class.to_s}" 
  # end

  def back sender
    dismiss
  end

  def approve sender
  end

  def unapprove sender
  end

  def save_remarks sender
  end

end