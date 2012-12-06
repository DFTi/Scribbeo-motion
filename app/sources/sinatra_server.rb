class SinatraServer < MediaSource::Server
  def initialize opts
    @mode = :sinatra
    super(opts)
  end
end