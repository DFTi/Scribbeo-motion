class AppDelegate
  attr_accessor :media_source

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # Setup default values needed 
    # Temporary until we setup the settings bundle and UI
    App::Persistence["networking"] = false
    App::Persistence["autodiscover"] = false
    App::Persistence["scheme"] = "http"
    App::Persistence["ip"] = "thundermini.local"
    App::Persistence["port"] = "8080"
    App::Persistence["username"] = ""
    App::Persistence["password"] = ""

    # ---- end temp values ---

    @media_source = MediaSource.new_from_settings
    
    @media_source.on(:contents_ready) do
      puts "Contents ready! Call .contents to populate your UI"
      puts "Recalling .fetch_contents will retrigger this block"
      # At this point we can trust that
      # media_source.contents will give us the right
      # contents, so we can present a view or update
      # and existing view with these contents
    end

    @media_source.on(:connection_ready) do
      puts "Connection ready! Fetching contents!"
      @media_source.fetch_contents
    end

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
