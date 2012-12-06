class ViewerController < UIViewController
  extend IB
  include ViewerHelper

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
    
    # then do something like this:
    # Player.load($source.contents[indexPath.row])

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
    @asset_table.delegate = self
    @asset_table.dataSource = $source
    @asset_table.reloadData
  end

end