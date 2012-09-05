class AppDelegate
  attr_accessor :media_source

  def application(application, didFinishLaunchingWithOptions:launchOptions)

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
