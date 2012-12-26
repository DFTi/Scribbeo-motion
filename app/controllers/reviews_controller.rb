class ReviewsController < ViewController::Landscape
  include Dismissable

  outlet :reviews_table
  outlet :remarks_done_button

  def viewDidLoad
    @reviews_table.dataSource = $source.reviews
    @reviews_table.reloadData
  end

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