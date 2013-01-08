//
//  CoreMedia_Timecodes.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 12/15/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//


#include "CoreMedia_Timecodes.h"

BOOL floatEquals(float a, float b, float tolerance);

#pragma mark - Constants

const CMTimecode CMTimcodeZero = {0,0,0,0,-1.f};

#pragma mark - CMTimecode

CMTimecode CMTimecodeFromCMTime(CMTime time, float framerate)
{
    
    // Get input in seconds
    Float64 seconds = CMTimeGetSeconds(time);
    Float64 realSeconds = seconds;
    
    //Round up
    framerate = ceilf(framerate);
    
    //Calculate minutes    
    NSInteger minutes = (NSInteger)floor(seconds / 60.) % 60;  
    //Calculate hours  
    NSInteger hours = (NSInteger)floor(seconds / 60.) - minutes;
    
    //Remove the number of seconds used for minutes and hours
    seconds -= (minutes * 60.) + (hours * 3600.);
    //Remove floating point trail 
    seconds = floor(seconds);
    
    Float64 totalFrames = realSeconds * framerate;
    //Every 1000th frame is dropped, this is the inverse ratio
    Float64 droppedFrameMagic = 1. - 1000./1001.;
    //Calculate the number of frames that have been dropped
    Float64 totalDroppedFrames = (totalFrames*droppedFrameMagic);
    
    //Remove the number of dropped frames in minutes and hours
    while (totalDroppedFrames >= framerate) {
        totalDroppedFrames -= framerate;//subtract 1 second in frames
        seconds -= 1;// subtract one second
        
        if (seconds < 0) {//if negative seconds remove a minute and increase to highest second before minute
            minutes -= 1;
            seconds = 59;
            
            if (minutes < 0) {//if negative minutes remove a minute and increase to the highest minute before hour
                hours -= 1;
                minutes = 59;
            }
        }
    }
    
    //Calculate in seconds the number of frames
    Float64 frameFloat = realSeconds - floor(realSeconds);
    
    //Calculate the number of frames
    NSInteger frame = frameFloat * framerate;
    
    //If the number of dropped frames is greater than frames this second
    if (totalDroppedFrames >= frame) {
        seconds -= 1;//Remove a second
        if (seconds < 0) {//if negative seconds remove a minute and increase to highest second before minute
            minutes -= 1;
            seconds = 59;
            
            if (minutes < 0) {//if negative minutes remove a minute and increase to the highest minute before hour
                hours -= 1;
                minutes = 59;
            }
        }
        
        //Remove the number of dropped frames from the new second
        frame = framerate - totalDroppedFrames;
        
    }else
    {
        //Remove the number of dropped frames
        frame -= totalDroppedFrames;
        
    }
    
    Float64 recalcedSeconds = (1./framerate*frame)+(seconds)+(60*minutes)+(60*60*hours) + (1./framerate*(totalFrames*droppedFrameMagic));
    
    NSInteger frameDiff = floor((realSeconds - recalcedSeconds)/(1.f/framerate));
    
    frame += frameDiff;
    
    return (CMTimecode){frame, seconds, minutes, hours, framerate};
    
}

CMTimecode CMTimecodeFromCMTimeWithoutDrop(CMTime time, float framerate)
{
    
    // Get input in seconds
    Float64 seconds = CMTimeGetSeconds(time);
    Float64 realSeconds = seconds;
    
    //Round up
    framerate = ceil(framerate);
    
    //Calculate minutes    
    NSInteger minutes = (NSInteger)floor(seconds / 60.) % 60;  
    //Calculate hours  
    NSInteger hours = (NSInteger)floor(seconds / 60.) - minutes;
    
    //Remove the number of seconds used for minutes and hours
    seconds -= (minutes * 60.) + (hours * 3600.);
    //Remove floating point trail 
    seconds = floor(seconds);
    
        //Calculate in seconds the number of frames
    Float64 frameFloat = realSeconds - floor(realSeconds);
    //Calculate the number of frames
    NSInteger frame = frameFloat * framerate;
    
    return (CMTimecode){frame, seconds, minutes, hours, framerate};
    
}

CMTime CMTimeFromCMTimecode(CMTimecode timecode)
{
    
    if (timecode.framerate > 0.f)
    {
        NSInteger framerate = ceilf(timecode.framerate) + 1;
        
        Float64 seconds = (Float64)(timecode.frames) / framerate;
        seconds += timecode.seconds;
        seconds += timecode.minutes * CMTimecodeSecondsInMinute;
        seconds += timecode.hours * CMTimecodeSecondsInHour;
        
        CMTime baseTime = CMTimeMakeWithSeconds(seconds, 1000000000);
        
        Float64 droppedFrameMagic = 1 - 1000./1001.;
        
        NSInteger frameCount = seconds * framerate * droppedFrameMagic;
                
        CMTime timeAdjust = CMTimeMakeWithSeconds( (Float64)frameCount / framerate , 1000000000);
        
        return CMTimeAdd(baseTime, timeAdjust);

    }
    
    return kCMTimeZero;
}

Float64 CMTimecodeGetSeconds(CMTimecode timecode)
{
    return CMTimeGetSeconds(CMTimeFromCMTimecode(timecode));
}

#pragma mark - Math

CMTimecode CMTimecodeAdd(CMTimecode addend1, CMTimecode addend2)
{
    
    if (floatEquals(addend1.framerate, addend2.framerate, CMTimecodeFramerateCompareTolerance)) {
        
        float framerate = addend1.framerate;//They should be the same TODO: average 2?
        
        NSInteger frames = addend1.frames + addend2.frames;
        
        NSInteger seconds = addend1.seconds + addend2.seconds;
        
        while (frames >= framerate){
            seconds += 1;
            frames -= framerate;
        }
        
        NSInteger minutes = addend1.minutes + addend2.minutes;
        
        while (seconds >= CMTimecodeSecondsInMinute){
            minutes += 1;
            seconds -= CMTimecodeSecondsInMinute;
        }
        
        NSInteger hours = addend1.hours + addend2.hours;
        
        while (minutes >= CMTimecodeMinutesInHour){
            hours += 1;
            minutes -= CMTimecodeMinutesInHour;
        }
        
        return (CMTimecode){frames, seconds, minutes, hours, framerate};
    }
    else
    {
        return CMTimcodeZero;
    }
}

#pragma mark - Helpers

BOOL floatEquals(float a, float b, float tolerance){
    
    return (fabs(a-b) < fabs(tolerance));
    
}

#pragma mark - NSString

NSString * NSStringFromCMTimecode(CMTimecode timecode)
{
    return [NSString stringWithFormat:@"%02i:%02i:%02i:%02i", timecode.hours, timecode.minutes, timecode.seconds, timecode.frames];
}

CMTimecode CMTimecodeFromNSString(NSString* timecode, float framerate)
{
    CMTimecode newTimecode = {0,0,0,0,0.f};
    
    NSArray* components = [timecode componentsSeparatedByString:@":"];
    
    if ([components count] == 4) {
        newTimecode.framerate = framerate;
        newTimecode.hours = [[components objectAtIndex:0] intValue];
        newTimecode.minutes = [[components objectAtIndex:1] intValue];
        newTimecode.seconds = [[components objectAtIndex:2] intValue];
        newTimecode.frames = [[components objectAtIndex:3] intValue];
        
        return newTimecode;
    }
    
    return CMTimcodeZero;
}