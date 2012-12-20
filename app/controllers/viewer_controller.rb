class ViewerController < ViewController::Landscape
  include MediaSource::Delegate
  
  outlet :asset_table
  outlet :note_table
  outlet :player_view
  outlet :note_text
  outlet :draw_button
  outlet :clear_button
  outlet :note_done_button
  outlet :save_button

  def backward(sender)
    p 'backward'
  end

  def forward(sender)
    p 'forward'
  end

  def next(sender)
    p 'next'
  end

  def previous(sender)
    p 'previous'
  end

  def viewDidLoad
    @asset_table.delegate = self
    @note_table.delegate = self
    @drawing_overlay = DrawView.new
    @drawing_overlay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    @drawing_overlay.contentMode = UIViewContentModeScaleToFill
    @drawing_overlay.backgroundColor = UIColor.clearColor
    update_draw_buttons
    @note_text.on(:editing_did_begin) {|n|
      $media_player.pause if $media_player
      @note_done_button.show!
    }
    @note_text.on(:editing_did_end) {|n| @note_done_button.hide! }
    @note_text.on(:editing_did_change) do |n|
      if $current_asset && !drawing?
        @save_button.hidden = !@note_text.has_text?
      end
    end
  end

  def done_typing(sender)
    @note_text.resignFirstResponder
  end

  def save(sender)
    note = Annotation.new :timecode=>"", :note=>@note_text.text,
      :seconds=>$media_player.seconds, :drawing=>@drawing_overlay.base64png
    $current_asset.create_note! note
  end

  # Handle selecting assets and notes
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    case tableView.dataSource
    when $source
      @note_text.resignFirstResponder
      $current_asset = $source.contents[indexPath.row]
      $current_asset.delegate = self
      url = NSURL.URLWithString "#{$current_asset.uri}?auth_token=#{$token}"
      if $media_player
        $media_player.contentURL = url
      else
        $media_player = MPMoviePlayerController.alloc.initWithContentURL(url)     
        $media_player.shouldAutoplay = false
        $media_player.view.frame = @player_view.bounds
        @player_view.addSubview $media_player.view
      end
      $media_player.prepareToPlay
      update_draw_buttons
      $current_asset.fetch_notes!
    when $current_asset
      present_note $current_asset.notes[indexPath.row]
      # Seek video to the note seconds
      # 
    end
  end

  def present_note(note)

  end

  # Draw button
  def draw(sender)
    drawing? ? stop_drawing! : start_drawing!
    update_draw_buttons
  end

  def clear(sender)
    @drawing_overlay.clear_drawing
  end

  private
  def update_draw_buttons
    if $current_asset
      @draw_button.show!
      if drawing?
        @draw_button.setTitle('cancel', forState:UIControlStateNormal)
        @clear_button.show!
        @save_button.show!
      else
        @draw_button.setTitle('draw', forState:UIControlStateNormal)
        @clear_button.hide!
        @save_button.hide! unless @note_text.has_text?
      end
    else
      @draw_button.hide!
      @clear_button.hide!
      @save_button.hide!
    end
  end
  def drawing?
    !@drawing_overlay.nil? && @drawing_overlay.superview
  end
  def stop_drawing!
    $media_player.controlStyle = MPMovieControlStyleDefault
    @drawing_overlay.removeFromSuperview
    @drawing_overlay.clear_drawing
  end
  def start_drawing!
    $media_player.pause
    $media_player.controlStyle = MPMovieControlStyleNone
    @drawing_overlay.frame = @player_view.bounds
    @player_view.addSubview(@drawing_overlay)
  end
end