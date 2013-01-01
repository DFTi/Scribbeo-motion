class AppDelegate
  attr_accessor :media_source

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    Crittercism.enableWithAppID("50d3864489ea74655000000b") unless Device.simulator?
    $source = nil
    $current_asset = nil
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    $viewer = load_vc("ViewerController")
    switch_to_vc $viewer
  rescue => ex
    App.alert ex.message
  ensure
    true
  end

  def applicationWillResignActive(application)
  end

  def load_vc(identifier)
    name = "#{Device.iphone? ? 'iPhone' : 'iPad'}Storyboard"
    storyboard = UIStoryboard.storyboardWithName(name, bundle: NSBundle.mainBundle)
    vc = storyboard.instantiateViewControllerWithIdentifier(identifier)
  end

  def switch_to_vc(vc)
    unless @window.rootViewController == vc
      @window.rootViewController = vc
      @window.rootViewController.wantsFullScreenLayout = true
      @window.makeKeyAndVisible
    end
  end
end
