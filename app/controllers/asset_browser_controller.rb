class AssetBrowserController < ViewController::Landscape
  
  def viewDidLoad
    if $source.nil? || !$source.connected?
      performSegueWithIdentifier('toSettings', sender:self)
    elsif Device.iphone?
      UIApplication.sharedApplication.setStatusBarHidden(true, animated:true)
    end
  end
end