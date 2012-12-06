class ViewerController < UIViewController
  extend IB
  include ViewerHelper

  def viewDidLoad
    NSLog 'view did load'
    if $source = new_source_from_settings
      $source.delegate = self
      $source.connect!
    else
      App.switch_to "SettingsController"
    end
  end

  def settings(sender)
    App.delegate.switch_to_vc App.delegate.load_vc("SettingsController")
  end

  # This is called when the media source has connected
  def connected
    NSLog 'Connected, VC knows this.'
    $source.fetch_contents!
  end

  def connection_failed
    NSLog 'Connection failed'
  end

  # Called when assets are available in the $source
  def contents_fetched
    NSLog "Contents fetched and available in $source.contents"
  end
end