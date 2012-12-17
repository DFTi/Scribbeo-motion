class AppDelegate
  attr_accessor :media_source

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    $source = nil
    UIApplication.sharedApplication.setStatusBarHidden(true, animated:false)
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    switch_to_vc load_vc("ViewerController")
  rescue => ex
    App.alert ex.message
  ensure
    true
  end

  def applicationWillResignActive(application)
    # Going into the background
    # Pause the player here
  end

  def applicationDidBecomeActive(application)
    # Resume code, e.g.:
    # Did any settings change?
    # If yes, cleanup the player and start from the beginning by reading settings
    # => and creating a new media source from it
    # If no, resume where we left off.
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
