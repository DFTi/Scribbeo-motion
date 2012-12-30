class CommentsController < ViewController::Landscape
  include Dismissable

  outlet :comments_table
  
  def viewDidLoad
    # $comments_controller = self
    # $current_asset.fetch_comments! do
    #   @comments_table.dataSource = $current_asset.comments
    #   @comments_table.reloadData
    # end
    super
  end

  def comments
    $current_asset.comments
  end

  def reply sender
    p 'reply?'
  end

  def back sender
    dismiss
  end
end