class BonjourFinder
  attr_writer :notify

  def initialize(service_type)
    @servers = []
    @search = service_type
    @browser = NSNetServiceBrowser.new
    @browser.delegate = self
  end

  def netServiceBrowser(browser, didFindService:service, moreComing:more_coming)
    return if @servers.include?(service)
    service.delegate = self
    service.resolveWithTimeout(100)
    @servers << service
  end

  def netServiceDidResolveAddress(sender)
    ip = NSHost.hostWithName(sender.hostName).address
    return if ip.include? ":" # No IPv6
    @browser.stop
    @target.instance_exec(ip, sender.port, &@block)
  end

  def server
    server = @servers.first
  end

  def notify(target, &block)
    @target = target
    @block = block
    @browser.searchForServicesOfType(@search, inDomain:"")
  end
end