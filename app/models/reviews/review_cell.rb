class ReviewCell < UITableViewCell
  attr_accessor :id

  module Tags
    CLIP_VIEW = 20
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

  def clip_view_image
    viewWithTag(ReviewCell::Tags::CLIP_VIEW_IMAGE)
  end

  def save_remarks_button
    viewWithTag(ReviewCell::Tags::SAVE_REMARKS_BUTTON)
  end

  def review=(r)
    clip_view_image.setImageWithURL r.image_url.nsurl
    status_label.text = r.status
    text_field.on(:editing_did_begin) {|n| done_button.show }
    text_field.on(:editing_did_end) {|n| done_button.hide }
    done_button.on(:touch_up_inside) {|n| text_field.resignFirstResponder }

    save_remarks_button.on(:touch_up_inside) do |n|
      update Review.new({ remarks: text_field, id: r.id })
    end

    approve_button.on(:touch_up_inside) do |n|
      update Review.new({ approve: true, id: r.id })
    end

    unapprove_button.on(:touch_up_inside) do |n|
      update Review.new({ approve: false, id: r.id })
    end
  end

  def update review
    $source.reviews.update_review!(review) do |user_feedback|
      if user_feedback[:success]
        App.alert "Review action updated on server."
      else
        App.alert "Review action could not be saved.\nError:#{user_feedback[:error]}"
      end
    end
  end
end