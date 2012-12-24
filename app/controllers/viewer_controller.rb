class ViewerController < ViewController::Landscape
  include ViewerHelper
  include BW::KVO

  outlet :player
  outlet :asset_table
  outlet :note_table
  outlet :note_text
  outlet :draw_button
  outlet :clear_button
  outlet :note_done_button
  outlet :save_button
  outlet :timecode

  def viewDidLoad
    @asset_table.delegate = self
    @note_table.delegate = self
    @note_text.on(:editing_did_begin) do |n|
      @player.pause if @player.exists?
      @note_done_button.show
    end
    @note_text.on(:editing_did_end) {|n| @note_done_button.hide }
    @note_text.on(:editing_did_change) do |n|
      if $current_asset && !drawing?
        @save_button.hidden = !@note_text.has_text?
      end
    end
    @presented_drawing = UIImageView.alloc.init
    @player.add_overlay @presented_drawing
    @presented_drawing.hide
    update_draw_buttons
  end

  def viewDidAppear animated
    if $source.nil? || !$source.connected?
      performSegueWithIdentifier('toSettings', sender:self)
    end
  end

  def done_typing sender
    @note_text.resignFirstResponder
  end

  def save sender
    $note = Note.new :timecode=>@timecode.text, :note=>@note_text.text,
      :seconds=>@player.seconds, :media_asset_id => $current_asset.id,
      :drawing=>(drew? ? @drawing_overlay.base64png : nil)
    $current_asset.create_note!($note) do |user_feedback|
      if user_feedback[:success]
        App.alert "Note saved on server.\nA local copy will appear momentarily."
        stop_drawing!
        @note_text.clear!
        $current_asset.fetch_notes!
      else
        App.alert "Note could not be saved.\nError:#{user_feedback[:error]}"
      end
    end
  end

  # Handle selecting assets and notes
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    stop_drawing!
    @presented_drawing.hide
    @note_text.resignFirstResponder
    @note_text.clear!
    case tableView.dataSource
    when $source # Selecting an Asset
      present_asset $source.contents[indexPath.row]
    when $current_asset # Selecting a Note
      present_note $current_asset.notes[indexPath.row]
    end
    update_draw_buttons
  end

  def present_asset asset
    $current_asset = asset
    $current_asset.delegate = self
    $current_asset.fetch_notes!
    $timecode_agent = TimecodeAgent.new($current_asset.fps, $current_asset.start_timecode)
    @timecode.text = TimecodeAgent::ZEROS
    player.load($current_asset) do |item|
      observe(item, :status) do |old_value, new_value|
        case new_value
        when AVPlayerItemStatusFailed
          App.alert 'Failed to load media. Check network / ensure file is not corrupt.'
          # When the value of this property is AVPlayerStatusFailed, you can no longer use the player for playback and you need to create a new instance to replace it. If this happens, you can check the value of the error property to determine the nature of the failure.
        when AVPlayerItemStatusReadyToPlay
          @timecode.text = $timecode_agent.timecode(@player.seconds)
          @player.observe_time do |time|
            @timecode.text = $timecode_agent.timecode(CMTimeGetSeconds(time))
            # self.scrubber.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.currentTrack.timeRange.duration);
          end
          unobserve(item, :status)
        end
      end
    end
  end

  def present_note note
    @note_text.text = note.text
    @player.seek_to note.seconds
    if note.has_drawing?
      @presented_drawing.setImageWithURL(note.drawing_url, placeholderImage:UIImage.new)
      @presented_drawing.show
    end
  end

  # Draw button
  def draw sender
    drawing? ? stop_drawing! : start_drawing!
  end

  def clear sender
    @drawing_overlay.clear_drawing
  end

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

  private
  def update_draw_buttons
    if $current_asset
      @draw_button.show
      if drawing?
        @draw_button.setTitle('cancel', forState:UIControlStateNormal)
        @clear_button.show
        @save_button.show
      else
        @draw_button.setTitle('draw', forState:UIControlStateNormal)
        @clear_button.hide
        @save_button.hide unless @note_text.has_text?
      end
    else
      @draw_button.hide
      @clear_button.hide
      @save_button.hide
    end
  end
  def drawing?
    !@drawing_overlay.nil? && !!@drawing_overlay.superview
  end
  def drew?
    drawing? && @drawing_overlay.has_input
  end
  def stop_drawing!
    if drawing?
      @drawing_overlay.removeFromSuperview
      @drawing_overlay.clear_drawing
    end
    update_draw_buttons
  end
  def start_drawing!
    @player.pause
    if @drawing_overlay.nil?
      @drawing_overlay = DrawView.new
      @drawing_overlay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
      @drawing_overlay.contentMode = UIViewContentModeScaleToFill
      @drawing_overlay.backgroundColor = UIColor.clearColor
    end
    @player.add_overlay(@drawing_overlay)
    update_draw_buttons
  end
end