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
    
    # @player.play $current_asset
    # @notes_table.reloadData -> $current_asset.annotations

    o = {
      allows_air_play:true,
      movie_source_type:MPMovieSourceTypeStreaming,
      should_autoplay:true
    }

    # movie_url = "http://localhost:9000/asset/testing/strawberries.mov"
    movie_url = $current_asset.uri+"?auth_token=#{$token}"

    $player.play(movie_url, o) do |media_player|
      begin
        media_player.view.frame = @player_view.bounds
        @player_view.addSubview media_player.view
      rescue => ex
        App.alert ex.message
      end
    end

  rescue => ex
    App.alert ex.message
  ensure
    NSLog "did select row at index path: #{indexPath.row}"
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