class ViewerController < ViewController::Base
  include ViewerHelper
  extend IB

  outlet :asset_table
  outlet :note_table

  outlet :player_view

  def viewDidLoad
    @asset_table.delegate = self
    @note_table.delegate = self
    $source = new_source_from_settings
    if $source.is_a? UIAlertView
      App.switch_to "SettingsController"
    elsif $source.is_a? EnterpriseServer
      $source.delegate = self
      $source.connect!
    end   
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
    $current_asset.fetch_notes!
  end

  def play_pause(sender)
    return unless $media_player
    if $media_player.playbackState == MPMoviePlaybackStatePlaying
      $media_player.pause
    else
      $media_player.play
    end
  end

  def draw(sender)
    NSLog 'draw hit'
    # if drawing
    #   get out of draw view, clear context, etc
    # else
    #   create overlay with view frame = to @player_view.bounds
    #   set up drawing context
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
    @note_table.dataSource = $current_asset
    @note_table.reloadData
  end
end