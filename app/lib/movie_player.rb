module MoviePlayer
  module Controls
    def backward(sender)
      p 'backward'
    end

    def forward(sender)
      p 'forward'
    end

    def next(sender)
      p 'next'
    end

    def previous(sender)
      p 'previous'
    end
  end

  class Controller < MPMoviePlayerController
    def seconds
      currentPlaybackTime
    end

    def timecode
      '01:01:01:01'
    end
  end
end