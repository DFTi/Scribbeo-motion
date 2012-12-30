class TimecodeAgent
  ZEROS = '00:00:00:00'
  attr_accessor :fps
  Timecode = Struct.new(:hours, :minutes, :seconds, :frames)

  def initialize(fps, start_tc=nil)
    @fps = fps.to_f
    @start_tc = start_tc
    if @start_tc
      @start_tc = parse_timecode(@start_tc)
    end
  end

  def print_timecode(hours, minutes, seconds, frames)
    htc = hours.to_i
    mtc = minutes.to_i
    stc = seconds.to_i
    ftc = frames.to_i
    htcs = htc < 10 ? "0#{htc}" : htc
    mtcs = mtc < 10 ? "0#{mtc}" : mtc
    stcs = stc < 10 ? "0#{stc}" : stc
    ftcs = ftc < 10 ? "0#{ftc}" : ftc
    "#{htcs}:#{mtcs}:#{stcs}:#{ftcs}"
  end

  def parse_timecode(timecode)
    hours = timecode[0..1].to_i
    minutes = timecode[3..4].to_i
    seconds = timecode[6..7].to_i
    frames = timecode[9..11].to_i
    Timecode.new hours, minutes, seconds, frames
  end

  def timecode(seconds)
    # Get input in seconds
    # seconds = units_to_seconds(time_units)
    realSeconds = seconds

    # Round up
    framerate = @fps.ceil

    # Calculate minutes
    minutes = (seconds / 60.0).floor % 60

    # Calculate hours
    hours = (seconds / 60.0).floor - minutes

    # Remove the number of seconds used for minutes and hours
    seconds -= (minutes * 60.0) + (hours * 3600.0)

    # Remove floating point trail
    seconds = seconds.floor

    totalFrames = realSeconds * framerate

    # Every 1000th frame is dropped, this is the inverse ratio
    droppedFrameMagic = 1.0 - 1000.0/1001.0
    # Calculate the number of frames that have been dropped
    totalDroppedFrames = (totalFrames * droppedFrameMagic)

    # Remove the number of dropped frames in minutes and hours  
    while totalDroppedFrames >= framerate
      totalDroppedFrames -= framerate # Subtract 1 second in frames
      seconds -= 1 # Subtract one second
      # If negative seconds
      if seconds < 0
        minutes -= 1 # Remove a minute and
        seconds = 59 # increase to highest second before minute

        # If negative minutes
        if minutes < 0
          hours -= 1 # Remove an hour and
          minutes = 59 # increase to highest minute before hour
        end
      end
    end

    # Calculate in seconds the number of frames
    frameFloat = realSeconds - realSeconds.floor

    # Calculate the number of frames
    frame = frameFloat * framerate

    # If number of dropped frames is greater than frames this second
    if totalDroppedFrames >= frame
      seconds -= 1 # Remove a second
      # If negative seconds
      if seconds < 0 
        minutes -= 1 # Remove a minute and
        seconds = 59 # increase to highest second before minute
        # If negative minutes
        if minutes < 0
          hours -= 1 # Remove a minute and
          minutes = 59 # increase to the highest minute before hour
        end
      end
      # Remove the number of dropped frames from the new second
      frame = framerate - totalDroppedFrames
    else
      # Remove the number of dropped frames
      frame -= totalDroppedFrames
    end

    recalcedSeconds = (1.0/framerate*frame) + 
      (seconds) + (60*minutes) + (60*60*hours) + 
      (1.0/framerate*(totalFrames*droppedFrameMagic))

    frameDiff = ((realSeconds - recalcedSeconds)/(1.0/framerate)).floor

    frame += frameDiff

    # Adjust timecode if start timecode is provided

    if @start_tc
      frames = frame + @start_tc.frames
      seconds = seconds + @start_tc.seconds
      while frames >= framerate
        seconds += 1
        frames -= framerate
      end
      minutes = minutes + @start_tc.minutes
      while seconds >= 60
        minutes += 1
        seconds -= 60
      end
      hours = hours + @start_tc.hours
      while minutes >= 60
        hours += 1
        minutes -= 60
      end
    end

    frame = 0 if frame >= framerate # reset impossible to 0
      
    print_timecode hours, minutes, seconds, frame
  end
end
