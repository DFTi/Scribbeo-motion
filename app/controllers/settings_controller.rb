class SettingsController < ViewController::Landscape
  outlet :networking
  outlet :autodiscover
  
  # server
  outlet :address
  outlet :port

  # login
  outlet :username
  outlet :password

  def viewDidLoad
    load_settings
    set_delegates
  end

  def textFieldShouldReturn(textfield)
    textfield.resignFirstResponder
  end

  def back(sender)
    save_settings
    NSLog "Saved settings, switching back to Viewer"
    $source = new_source_from_settings
    unless $source.is_a? UIAlertView
      $source.delegate = presentingViewController
      $source.connect!
      presentingViewController.dismissViewControllerAnimated(true, completion:nil)
    end
  end

  private
  def load_settings
    @networking.on = App::Persistence["networking"]
    @autodiscover.on = App::Persistence["autodiscover"]
    if server = App::Persistence["server"]
      @address.text = server['address']
      @port.text = server['port']
    end
    if login = App::Persistence["login"]
      @username.text = login['username']
      @password.text = login['password']
    end
  end

  def save_settings
    App::Persistence["networking"] = @networking.on?
    App::Persistence["autodiscover"] = @autodiscover.on?
    App::Persistence["server"] = {address: @address.text, port: @port.text}
    App::Persistence["login"] = {username: @username.text, password: @password.text}
  end

  # Set delegates such that the keyboard will go away on Done
  def set_delegates
    @address.delegate = self
    @port.delegate = self
    @username.delegate = self
    @password.delegate = self
  end

  private
  def new_source_from_settings
    if Persistence["networking"]
      server = Persistence['server'].nil? ? Hash.new : Persistence['server']
      port_entered = !server['port'].nil? && !server['port'].empty?
      address_entered = !server['address'].nil? && !server['address'].empty?
      server_entered = ((port_entered && address_entered) ? true : false)
      if Persistence["autodiscover"]
        PythonServer.new autodiscover: true
      elsif server_entered
        uri = "http://#{server['address']}:#{server['port']}"
        if login = Persistence["login"]
          EnterpriseServer.new base_uri:uri, login: login
        else
          PythonServer.new base_uri:uri, autodiscover: false
        end
      else
        App.alert MediaSource::Alert::INVALID_SETTINGS
      end
    else
      LocalMedia.new
    end
  end
end