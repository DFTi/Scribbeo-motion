class PlayerView < UIView

  def load asset
    if $media_player
      $media_player.contentURL = asset.playback_url
    else
      $media_player = MoviePlayer::Controller.alloc.initWithContentURL asset.playback_url
      $media_player.shouldAutoplay = false
      $media_player.view.frame = self.bounds
      self.addSubview $media_player.view
    end
    $media_player.prepareToPlay
  end

  def seek_to seconds
    $media_player.currentPlaybackTime = seconds
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