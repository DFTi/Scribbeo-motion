class PlayerView < UIView

  def load asset
    if mp
      mp.contentURL = asset.playback_url
    else
      mp = MoviePlayer::Controller.alloc.initWithContentURL asset.playback_url
      mp.shouldAutoplay = false
      mp.view.frame = self.bounds
      self.addSubview mp.view
    end
    mp.prepareToPlay
  end

  def seek_to seconds
    mp
  end

  def exists?
    !mp.nil?
  end

  def pause
    mp.pause
  end

  def show_control_overlay
    mp.controlStyle = MPMovieControlStyleDefault
  end

  def hide_control_overlay
    mp.controlStyle = MPMovieControlStyleNone
  end

  def seconds
    mp.seconds
  end

  def add_overlay(overlay)
    overlay.frame = mp.view.bounds
    mp.view.addSubview(overlay)
  end

  private
  def mp ; $media_player ; end
  def method_missing(method, *args, &block)  
    if mp.respond_to? method
      mp.send(method, *args, &block)
    else
      NSLog "MoviePlayer::Controller does not respond to #{method}"
    end
  end
end