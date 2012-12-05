class ViewerController < UIViewController
  extend IB
  attr_accessor :data_source

  def viewDidLoad

  end

  def settings(sender)
    App.delegate.switch_to_vc App.delegate.load_vc("SettingsController")
  end

end