module BonjourExtension
  def server=(server)
    @config[:server] = server
  end

  def bonjour_found(ip, port)
    @config[:base_uri] = "http://#{ip}:#{port}"
    @uri = @config[:base_uri]+'/list'
  end
end