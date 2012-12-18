class SettingsController < ViewController::Base
  extend IB

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
    presentingViewController.dismissViewControllerAnimated(true, completion:nil)
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
end