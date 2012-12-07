class ViewerController < ViewController::Landscape
  include ViewerHelper
  extend IB

  outlet :asset_table

  def viewDidLoad
    $source = new_source_from_settings
    if $source.is_a? UIAlertView
      App.switch_to "SettingsController"
    else
      $source.delegate = self
      $source.connect!
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    $current_asset = $source.contents[indexPath.row]
    
    # @player.play $current_asset
    # @notes_table.reloadData -> $current_asset.annotations

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