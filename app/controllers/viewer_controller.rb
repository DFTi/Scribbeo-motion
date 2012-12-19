class ViewerController < ViewController::Landscape
  attr_reader :drawing_overlay

  outlet :player_view

  outlet :draw_button
  outlet :clear_button

  outlet :asset_table
  outlet :note_table

  outlet :note_text
  outlet :note_done_button

  def viewDidLoad
    @asset_table.delegate = self
    @note_table.delegate = self
    @drawing_overlay = DrawView.new
    @drawing_overlay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    @drawing_overlay.contentMode = UIViewContentModeScaleToFill
    @drawing_overlay.backgroundColor = UIColor.clearColor
    update_draw_buttons
    @note_text.on(:editing_did_begin) {|n| @note_done_button.hidden = false }
    @note_text.on(:editing_did_end) {|n| @note_done_button.hidden = true }
  end

  def done_typing(sender)
    @note_text.resignFirstResponder
  end

  # Handle selecting assets and notes
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    case tableView.dataSource
    when $source
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
    if drawing_overlay.superview
      drawing_overlay.removeFromSuperview
    else
      $media_player.pause
      drawing_overlay.frame = @player_view.bounds
      @player_view.addSubview(drawing_overlay)
    end
    update_draw_buttons
  end

  def clear_drawing(sender)
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
        @draw_button.setTitle('done', forState:UIControlStateNormal)
        @clear_button.hidden = false  
      else
        @draw_button.setTitle('draw', forState:UIControlStateNormal)
        @clear_button.hidden = true
      end
    else
      @draw_button.hidden = true
      @clear_button.hidden = true
    end
  end
end