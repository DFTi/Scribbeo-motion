class ReviewsController < ViewController::Landscape
  include Dismissable

  outlet :reviews_table

  def viewDidLoad
    $reviews_controller = self
    reviews.fetch_reviews! do
      @reviews_table.dataSource = $source.reviews
      @reviews_table.reloadData
    end
    super
  end

  def reviews
    $source.reviews
  end

  def back sender
    dismiss
  end
end