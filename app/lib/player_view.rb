class PlayerView < UIView
  def load_asset(asset)
    url = asset.playback_url
    if $media_player
      $media_player.contentURL = url
    else
      $media_player = MoviePlayer::Controller.alloc.initWithContentURL(url)     
      $media_player.shouldAutoplay = false
      $media_player.view.frame = self.bounds
      self.addSubview $media_player.view
    end
    $media_player.prepareToPlay
  end
  def load_note

  end

  def exists?
    !$media_player.nil?
  end

  def pause
    $media_player.pause
  end

  def show_control_overlay
    $media_player.controlStyle = MPMovieControlStyleDefault
  end

  def hide_control_overlay
    $media_player.controlStyle = MPMovieControlStyleNone
  end

  def seconds
    $media_player.seconds
  end

  def add_overlay(overlay)
    overlay.frame = $media_player.view.bounds
    $media_player.view.addSubview(overlay)
  end
end