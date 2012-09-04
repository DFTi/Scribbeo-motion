class AppDelegate
  attr_accessor :media_source, :debug

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @debug = nil
    # Setup default values needed 
    # Temporary until we setup the settings bundle and UI
    Persistence["networking"] = true
    Persistence["autodiscover"] = true
    Persistence["scheme"] = "http"
    Persistence["ip"] = "keyvan-mbp.local"
    Persistence["port"] = "8080"
    Persistence["username"] = ""
    Persistence["password"] = ""

    # ---- end temp values ---

    @media_source = MediaSource.new_from_settings
    bindMediaSourceEvents

    # Set up the UI however way you want
    # Let the event handlers notify you of stuff you care about ...

    true
  end

  def bindMediaSourceEvents
    @media_source.on(:contents_fetched) do
      puts "Contents ready! Use App.media_source.contents to retrieve"
      puts "Recalling .fetch_contents will retrigger this block"
      # At this point we can trust that
      # media_source.contents will give us the right
      # contents, so we can present a view or update
      # and existing view with these contents
    end

    @media_source.on(:connected) do
      puts "Connection ready! Fetching contents!"
      @media_source.fetch_contents
    end

    @media_source.on(:connection_failed) do
      puts "Connection failed..."
    end

    @media_source.on(:ready_to_connect) do
      puts "Ready"
      @media_source.connect
    end
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
