class SettingsController < UIViewController
  extend IB

  outlet :networking
  outlet :autodiscover
  
  # server
  outlet :address
  outlet :port

  # login
  outlet :username
  outlet :password

  outlet :test_button

  def viewDidLoad
    # Load vars from Persistence
  end

  def viewDidUnload
    # Save vars into Persistence
  end

  def test(sender)
    
  end

  def back(sender)
    App.switch_to('ViewerController')
  end

end