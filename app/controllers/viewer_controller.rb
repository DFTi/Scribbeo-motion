class ViewerController < UIViewController
  extend IB

  def viewDidLoad
    NSLog 'view did load'
    if $source = source_from_settings
      $source.delegate = self
      $source.connect
    else
      App.switch_to "SettingsController"
    end
  end

  # IB Actions
  def settings(sender)
    App.delegate.switch_to_vc App.delegate.load_vc("SettingsController")
  end

  # This is called when the media source has connected
  def connected
    NSLog 'Connected, VC knows this.'
    # clear asset list list
    # populate it with $source.contents
  end

  def connection_failed
    NSLog 'Connection failed'
  end

  private
  def source_from_settings
    if Persistence["networking"]
      if Persistence["autodiscover"]
        PythonServer.new autodiscover: true
      elsif server = Persistence["server"]
        uri = "http://#{server['address']}:#{server['port']}"
        if login = Persistence["login"]
          EnterpriseServer.new base_uri:uri, login: login
        else
          PythonServer.new base_uri:uri, autodiscover: false
        end
      else
        App.alert "Network mode requires target server address & port, \
        Alternatively, use autodiscover or disable networking."
        return false
      end
    else
      LocalMedia.new
    end
  end
end