class ViewerController < ViewController::Landscape
  attr_reader :drawing_overlay

  outlet :player_view

  outlet :draw_button
  outlet :clear_button

  outlet :asset_table
  outlet :note_table

  outlet :note_text
  outlet :note_done_button

  outlet :save_button

  def viewDidLoad
    @asset_table.delegate = self
    @note_table.delegate = self
    $d = @drawing_overlay = DrawView.new
    @drawing_overlay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    @drawing_overlay.contentMode = UIViewContentModeScaleToFill
    @drawing_overlay.backgroundColor = UIColor.clearColor
    update_draw_buttons
    @note_text.on(:editing_did_begin) {|n|
      $media_player.pause if $media_player
      @note_done_button.hidden = false
    }
    @note_text.on(:editing_did_end) {|n| @note_done_button.hidden = true }
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
    # Annotation.new()
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
        $media_player.controlStyle = MPMovieControlStyleNone
        $media_player.view.frame = @player_view.bounds
        @player_view.addSubview $media_player.view
      end
      $media_player.prepareToPlay
      update_draw_buttons
      $current_asset.fetch_notes!
    when $current_asset
      NSLog("TAPPED ON A NOTE")
    end
  end

  # Play button
  def play_pause(sender)
    return unless $media_player
    if $media_player.playbackState == MPMoviePlaybackStatePlaying
      $media_player.pause
    else
      $media_player.play
    end
  end

  # Draw button
  def draw(sender)
    drawing? ? stop_drawing! : start_drawing!
    update_draw_buttons
  end

  def clear(sender)
    drawing_overlay.clear_drawing
  end

  ## MediaSource delegate methods:

  def connected
    $source.fetch_contents!
  end

  def connection_failed
    App.alert MediaSource::Alert::CONNECTION_FAILURE
  end

  def contents_fetched
    @asset_table.dataSource = $source
    @asset_table.reloadData
  end

  def notes_fetched
    NSLog("NOTES FETCHED RELOAD DATA")
    @note_table.dataSource = $current_asset
    @note_table.reloadData
  end

  private
  def update_draw_buttons
    if $current_asset
      @draw_button.hidden = false
      if @drawing_overlay && @drawing_overlay.superview
        @draw_button.setTitle('cancel', forState:UIControlStateNormal)
        @clear_button.hidden = false
        @save_button.hidden = false
      else
        @draw_button.setTitle('draw', forState:UIControlStateNormal)
        @clear_button.hidden = true
        @save_button.hidden = true unless @note_text.has_text?
      end
    else
      @draw_button.hidden = true
      @clear_button.hidden = true
      @save_button.hidden = true
    end
  end
  def drawing?
    drawing_overlay.superview
  end
  def stop_drawing!
    drawing_overlay.removeFromSuperview
    drawing_overlay.clear_drawing
  end
  def start_drawing!
    $media_player.pause
    drawing_overlay.frame = @player_view.bounds
    @player_view.addSubview(drawing_overlay)
  end
end