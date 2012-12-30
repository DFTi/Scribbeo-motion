class ReviewCell < UITableViewCell
  attr_accessor :id

  module Tags
    CLIP_VIEW_IMAGE = 200
    TEXT_FIELD = 21
    APPROVE_BUTTON = 22
    UNAPPROVE_BUTTON = 23
    STATUS_LABEL = 24
    DONE_BUTTON = 25
    SAVE_REMARKS_BUTTON = 26
  end
  
  def approve_button
    viewWithTag(ReviewCell::Tags::APPROVE_BUTTON)
  end

  def unapprove_button
    viewWithTag(ReviewCell::Tags::UNAPPROVE_BUTTON)
  end

  def done_button
    viewWithTag(ReviewCell::Tags::DONE_BUTTON)
  end

  def text_field
    viewWithTag(ReviewCell::Tags::TEXT_FIELD)
  end

  def status_label
    viewWithTag(ReviewCell::Tags::STATUS_LABEL)
  end

  def set_status(str)
    status_label.text = str
  end

  def clip_view_image
    viewWithTag(ReviewCell::Tags::CLIP_VIEW_IMAGE)
  end

  def save_remarks_button
    viewWithTag(ReviewCell::Tags::SAVE_REMARKS_BUTTON)
  end

  def started_editing
    done_button.show
    cell_size = self.frame.size
    table_view.contentInset=UIEdgeInsetsMake(0,0,200,0);
    table_view.setContentOffset(CGPointMake(0, 200), animated:true)
  end

  def stopped_editing
    done_button.hide
    table_view.contentInset=UIEdgeInsetsMake(0,0,0,0);
    table_view.scrollToRowAtIndexPath(NSIndexPath.indexPathForRow(0,inSection:0), 
      atScrollPosition:UITableViewScrollPositionTop, animated:true)
  end

  def table_view
    superview
  end

  def preview
    mpvc = MPMoviePlayerViewController.alloc.initWithContentURL @stream_url
    $reviews_controller.presentMoviePlayerViewControllerAnimated(mpvc)
  end

  def review=(r)
    @stream_url = "#{r.stream_url}?auth_token=#{$token}".nsurl # save for later :)
    clip_view_image.setImageWithURL r.image_url.nsurl
    status_label.text = r.status
    text_field.on(:editing_did_begin) {|n| started_editing }
    text_field.on(:editing_did_end) {|n| stopped_editing }
    done_button.on(:touch_up_inside) {|n| text_field.resignFirstResponder }

    save_remarks_button.on(:touch_up_inside) do |n|
      update(r.id, remarks: text_field.text) if text_field.text.size > 0
    end

    approve_button.on(:touch_up_inside) do |n|
      update(r.id, approve: true) { set_status 'Approved'}
    end

    unapprove_button.on(:touch_up_inside) do |n|
      update(r.id, approve: false) { set_status 'Unapproved'}
    end

    single_tap = UITapGestureRecognizer.alloc.initWithTarget(self, action: :preview)
    single_tap.numberOfTapsRequired = 1;
    single_tap.numberOfTouchesRequired = 1;
    clip_view_image.addGestureRecognizer(single_tap)
    clip_view_image.setUserInteractionEnabled(true)
  end

  def update(review_id, params, &block)
    review = Review.new({id:review_id}.merge(params))
    $source.reviews.update_review!(review) do |user_feedback|
      if user_feedback[:success]
        block.call unless block.nil?
      else
        App.alert user_feedback[:message]
      end
    end
  end
end