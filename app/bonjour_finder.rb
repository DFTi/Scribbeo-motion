class BonjourFinder
  attr_writer :notify

  def initialize(search)
    @servers = []
    @search = search
    @browser = NSNetServiceBrowser.new
    @browser.delegate = self
  end

  def start
    stop
    @browser.searchForServicesOfType(@search, inDomain:"")
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
    ip = NSHost.hostWithName(sender.hostName).address
    port = sender.port
    @block.call(ip, port)
    stop
  end

  def server
    server = @servers.first
  end

  def notify(&block)
    @block = block
    start
  end
end