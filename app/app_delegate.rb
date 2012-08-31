class AppDelegate
  attr_accessor :media_source
  include BubbleWrap::KVO

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # Setup default values needed 
    # Temporary until we setup the settings bundle and UI
    
    @media_source = MediaSource.new_from_settings
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

end
