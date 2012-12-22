class SettingsController < ViewController::Landscape
  outlet :networking
  outlet :autodiscover
  outlet :address
  outlet :port
  outlet :username
  outlet :password

  def viewDidLoad
    load_settings
    set_delegates
  end

  def connect sender
    save_settings
    $source = MediaSource::Factory.build
    $source.delegate = presentingViewController
    $source.connect! {|status| dismiss if status == :connected}
  rescue MediaSource::InvalidSettingsError
    App.alert MediaSource::Alert::INVALID_SETTINGS
  end

  def back sender
    dismiss
  end

  private
  def dismiss
    if presentingViewController
      presentingViewController.dismissViewControllerAnimated(true, completion:nil)
    end
  end

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
end