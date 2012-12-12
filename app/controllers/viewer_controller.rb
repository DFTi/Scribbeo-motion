class ViewerController < ViewController::Landscape
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
    url = NSURL.URLWithString "#{$current_asset.uri}?auth_token=#{$token}"
    if $media_player
      $media_player.contentURL = url
    else
      $media_player = MPMoviePlayerController.alloc.initWithContentURL(url)
    end
    $media_player.allowsAirPlay = true
    $media_player.movieSourceType = $source.type
    $media_player.shouldAutoplay = false
    $media_player.useApplicationAudioSession = true
    $media_player.view.frame = @player_view.bounds
    @player_view.addSubview $media_player.view
    $current_asset.fetch_notes!
  end

  def settings(sender)
    App.switch_to "SettingsController"
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