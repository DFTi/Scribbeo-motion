class BonjourFinder
  include EM::Eventable

  def initialize
    @servers = []
    @browser = NSNetServiceBrowser.new
    @browser.delegate = self
  end

  def start
    stop
    @browser.searchForServicesOfType("_videoTree._tcp.", inDomain:"")
  end

  def stop
    @browser.stop
  end

  def netServiceBrowser(browser, didFindService:service, moreComing:more_coming)
    return if @servers.include?(service)
    service.delegate = self
    service.resolveWithTimeout(100)
    @servers << service
  end

  def netServiceDidResolveAddress(sender)
    trigger(:found_bonjour_server)
  end

  def server
    @servers.first
  end
end