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
    # address.returnKeyType = UIReturnKeyDone;
    # address.delegate = self;
    # http://stackoverflow.com/questions/5151808/how-to-hide-keyboard-in-uiviewcontroller-on-return-button-click-iphone
    # textFieldTwo.returnKeyType = UIReturnKeyDone;
    # textFieldCislo.delegate = self;
  end

  def test(sender)
    # Test it, if it works, turn into "Save", which will apply to Persistence
    # if it doesnt work, stay as Test
  end

  def back(sender)
    App.switch_to('ViewerController')
  end

  def textFieldShouldReturn(textfield)
    textfield.resignFirstResponder
  end

end