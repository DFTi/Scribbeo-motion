module MediaSource
  class Server < Base

    def initialize opts
      @base_uri = opts[:base_uri]
      @login = opts[:login]
      super
    end

    def api(path='')
      raise SubclassMissingError
    end

    def type
      MPMovieSourceTypeStreaming
    end
  end
end