class BonjourFinder
  attr_reader :servers
  include EM::Eventable

  def initialize(media_source)
    @servers = []
    @browser = NSNetServiceBrowser.new
    @browser.delegate = self
    @browser.searchForServicesOfType("_videoTree._tcp.", inDomain:"")
    @media_source = media_source
  end

  def netServiceBrowser(browser, didFindService:service, moreComing:more_coming)
    return if @servers.include?(service)
    service.resolve
    @servers << service
    @browser.stop
    @browser = nil
  end

  def netServiceDidResolveAddress(service)
    # @media_source.python_discovered(service.hostName[0..-2], service.port)
    puts "!!!!!!!!!!!=> "+service.hostName
  end

  def server
    @servers.first
  end

end