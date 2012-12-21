class MoviePlayer < MPMoviePlayerController
  def seconds
    currentPlaybackTime
  end
end