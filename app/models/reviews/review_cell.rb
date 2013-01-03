class ReviewCell < UITableViewCell
  Tags(clip_view_image:200, text_field:21, status_label:24, approve_button:22,
    unapprove_button:23, done_button:25, save_remarks_button:26)
  
  def set_status(str)
    status_label.text = str
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