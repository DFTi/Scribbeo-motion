class AppDelegate
  attr_accessor :media_source

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    Crittercism.enableWithAppID("50d3864489ea74655000000b")
    $source = nil
    $media_player = nil
    $current_asset = nil
    UIApplication.sharedApplication.setStatusBarHidden(true, animated:false)
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    switch_to_vc load_vc("ViewerController")
  rescue => ex
    App.alert ex.message
  ensure
    true
  end

  def applicationWillResignActive(application)
    $media_player.pause if $media_player
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
