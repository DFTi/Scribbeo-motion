class ViewerController < ViewController::Landscape
  include ViewerHelper
  extend IB

  outlet :asset_table

  outlet :player_view

  def viewDidLoad
    $player = BW::Media::Player.new
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
    url = NSURL.URLWithString "#{$current_asset.uri}?auth_token=#{$token}"
    $media_player = MPMoviePlayerController.alloc.initWithContentURL(url)
    $media_player.allowsAirPlay = true
    $media_player.movieSourceType = $source.type
    $media_player.shouldAutoplay = false
    $media_player.useApplicationAudioSession = true
    $media_player.view.frame = @player_view.bounds
    @player_view.addSubview $media_player.view
    # @notes_table.reloadData -> $current_asset.annotations
  end

  def settings(sender)
    App.switch_to "SettingsController"
  end

  ## MediaSource delegate methods:

  def connected
    NSLog "Connected. Fetching contents now."
    $source.fetch_contents!
  end

  def connection_failed
    App.alert 'Failed to connect. Check settings or network connectivity.'
  end

  def contents_fetched
    NSLog "Contents fetched and available in $source.contents. Reloading @asset_table"
    @asset_table.dataSource = $source
    @asset_table.delegate = self
    @asset_table.reloadData
  end
end