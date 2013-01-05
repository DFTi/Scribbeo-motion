class SettingsController < ViewController::Base

  outlet :networking
  outlet :autodiscover
  outlet :address
  outlet :port
  outlet :username
  outlet :password
  outlet :apply_button

  def viewDidLoad
    UIApplication.sharedApplication.setStatusBarHidden(false, animated:true)
    @address.delegate = self
    @port.delegate = self
    @username.delegate = self
    @password.delegate = self
    load_settings
    super
  end

  def apply sender
    @apply_button.hide
    save_settings
    if $source = MediaSource::Builder.build
      $source.delegate = presentingViewController
      $source.connect! do |status, reply|
        @apply_button.show
        case status
        when :connected; dismiss
        when :connection_failure
          case reply['message']
          when '401 Unauthorized'
            App.alert "Authentication failed. Check username & password."
          when 'NoResponse'
            App.alert 'Server is not responding. Check address & port or contact an administrator.'
          when 'BadResponse'
            App.alert 'Server gave an unexpected response. Please contact an administrator.'
          end
        end
      end
    else
      App.alert MediaSource::Alert::INVALID_SETTINGS
    end
  end

  def cancel sender
    dismiss
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
end