//
//  SBMediaPlayerController.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/18/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "SBAssetPlayerVC.h"
#import "SBAssetPlayerV.h"
#import "SBAssetPlayerScrubberVC.h"

#import "UIView+Rendering.h"

#import <QuartzCore/QuartzCore.h>

enum FrameResponderTags {
    
    //Frame adjust
    FrameResponderNextFrame = 0,
    FrameResponderPrevFrame,
    FrameResponderNextSecond,
    FrameResponderPrevSecond,
    FrameResponderNextTenSeconds,
    FrameResponderPrevTenSeconds,
    
    FrameResponderFFW,//6
    FrameResponderRRW
    
};


static CMTimecode getAssetPlayerTimecode(AVPlayer *player)
{
    
    if (!player) {
        return CMTimcodeZero;
    }
    
    AVPlayerItem *playerItem = player.currentItem;
    AVAsset * playerAsset = playerItem.asset;
    AVAssetTrack *playerAssetVideoTrack = [[playerAsset tracksWithMediaType:AVMediaTypeVideo] lastObject];
    //AVAssetTrack *playerAssetTimecodeTrack = [[playerAsset tracksWithMediaType:AVMediaTypeTimecode] lastObject];
    
    
    float framerate = playerAssetVideoTrack.nominalFrameRate;
    
    //CMTime startTime = CMTimeMakeWithSeconds(playerAssetTimecodeTrack.timeRange.start, playerAssetVideoTrack.naturalTimeScale);
 
    // CMTimeCodeFormatDescriptionGetTimeCodeFlags();
    // kCMTimeCodeFlag_DropFrame
    
    CMTimecode timecode = CMTimecodeFromCMTime(player.currentTime, framerate);
    CMTimecode startTimecode = CMTimecodeFromNSString(@"00:58:00:00", framerate);    
    timecode = CMTimecodeAdd(timecode, startTimecode);

    return timecode;
}

#pragma mark Class Extension

@interface SBAssetPlayerVC ()

@property (nonatomic, strong) IBOutlet SBAssetPlayerV *playerView;
@property (nonatomic, assign) IBOutlet UIView *gestureView;

@property (nonatomic, strong) id playerTimeObserver;

@property (nonatomic, assign) AVPlayer *player;
@property (nonatomic, assign) AVAssetTrack *currentTrack;

@property (nonatomic) CGFloat playerRateStorage;

//Rewrite property for internal usage
@property (nonatomic, readwrite) CMTimecode currentTimecode;


- (AVAssetTrack*)currentTrack;

- (void)frameAdjustResponder:(id)sender;
- (void)scrubberDidMove:(UISlider*)slider;

- (IBAction)beginRateAdjustResponder:(UIButton*)sender;
- (IBAction)endRateAdjustResponder:(UIButton*)sender;
- (IBAction)playbackResponder:(UIButton*)sender;


@end

#pragma mark - Class Implementation

@implementation SBAssetPlayerVC

#pragma mark - Public properties

@synthesize assetURL;
@synthesize startTimecode;
@synthesize currentTimecode;
@synthesize controlsDisabled;
@synthesize scrubber;

#pragma mark - Private properties

@synthesize playerView;
@synthesize gestureView;

@synthesize playerTimeObserver;

@synthesize player;
@synthesize currentTrack;

@synthesize playerRateStorage;

#pragma mark - View lifecycle

+ (SBAssetPlayerVC*)assetPlayerVC
{
    return [[SBAssetPlayerVC alloc] initWithNibName:@"SBAssetPlayerVC" bundle:nil];
}

- (void)viewDidLoad
{
    
    self.controlsDisabled = NO;
    
    // 1 Frame
    UISwipeGestureRecognizer * GRForwardAdjustFrame = [[UISwipeGestureRecognizer alloc] init];
    GRForwardAdjustFrame.direction = UISwipeGestureRecognizerDirectionLeft;
    GRForwardAdjustFrame.numberOfTouchesRequired = 1;
    [GRForwardAdjustFrame addTarget:self action:@selector(frameAdjustResponder:)];
    [self.gestureView addGestureRecognizer:GRForwardAdjustFrame];
    GRForwardAdjustFrame = nil;
    
    // 1 Sec
    GRForwardAdjustFrame = [[UISwipeGestureRecognizer alloc] init];
    GRForwardAdjustFrame.direction = UISwipeGestureRecognizerDirectionLeft;
    GRForwardAdjustFrame.numberOfTouchesRequired = 2;
    [GRForwardAdjustFrame addTarget:self action:@selector(frameAdjustResponder:)];
    [self.gestureView addGestureRecognizer:GRForwardAdjustFrame];
    GRForwardAdjustFrame = nil;
    
    // 10 Sec
    GRForwardAdjustFrame = [[UISwipeGestureRecognizer alloc] init];
    GRForwardAdjustFrame.direction = UISwipeGestureRecognizerDirectionLeft;
    GRForwardAdjustFrame.numberOfTouchesRequired = 3;
    [GRForwardAdjustFrame addTarget:self action:@selector(frameAdjustResponder:)];
    [self.gestureView addGestureRecognizer:GRForwardAdjustFrame];
    GRForwardAdjustFrame = nil;
    
    // 1 frame
    UISwipeGestureRecognizer * GRBackwardsAdjustFrame = [[UISwipeGestureRecognizer alloc] init];
    GRBackwardsAdjustFrame.direction = UISwipeGestureRecognizerDirectionRight;
    GRBackwardsAdjustFrame.numberOfTouchesRequired = 1;
    [GRBackwardsAdjustFrame addTarget:self action:@selector(frameAdjustResponder:)];
    [self.gestureView addGestureRecognizer:GRBackwardsAdjustFrame];
    GRBackwardsAdjustFrame = nil;
    
    // 1 Sec
    GRBackwardsAdjustFrame = [[UISwipeGestureRecognizer alloc] init];
    GRBackwardsAdjustFrame.direction = UISwipeGestureRecognizerDirectionRight;
    GRBackwardsAdjustFrame.numberOfTouchesRequired = 2;
    [GRBackwardsAdjustFrame addTarget:self action:@selector(frameAdjustResponder:)];
    [self.gestureView addGestureRecognizer:GRBackwardsAdjustFrame];
    GRBackwardsAdjustFrame = nil;
    
    // 10 Sec
    GRBackwardsAdjustFrame = [[UISwipeGestureRecognizer alloc] init];
    GRBackwardsAdjustFrame.direction = UISwipeGestureRecognizerDirectionRight;
    GRBackwardsAdjustFrame.numberOfTouchesRequired = 3;
    [GRBackwardsAdjustFrame addTarget:self action:@selector(frameAdjustResponder:)];
    [self.gestureView addGestureRecognizer:GRBackwardsAdjustFrame];
    GRBackwardsAdjustFrame = nil;
    
    // Play/Pause
    UITapGestureRecognizer *GRTapPlayback = [[UITapGestureRecognizer alloc] init];
    GRTapPlayback.numberOfTouchesRequired = 1;
    [GRTapPlayback addTarget:self action:@selector(playbackResponder:)];
    [self.gestureView addGestureRecognizer:GRTapPlayback];
    
    
    // Long press doesn't behave as intended, began coding custom recognizer
    // SBHoldGestureRecognizer
    
    /*UILongPressGestureRecognizer *GRLongPress = [[UILongPressGestureRecognizer alloc] init];
    GRLongPress.minimumPressDuration = kHoldGestureMinimumLength;
    GRLongPress.numberOfTouchesRequired = 1;
    GRLongPress addTarget:self action:@selector(hold)*/
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    playerView = nil;
}


#pragma mark - Setters

#define kCMTimeAccurateTimescale 10000


- (void)setAssetURL:(NSURL *)newAssetURL
{
    
    assetURL = newAssetURL;
    
    if (newAssetURL)
    {
        
        NSString *urlExtension = [newAssetURL pathExtension];
        
        self.parentViewController.navigationItem.title = [newAssetURL lastPathComponent];
        
        if ([urlExtension isEqualToString:@"mov"])
        {
            
            if (player)
            {
                [player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:newAssetURL]];
            }
            else
            {
                
               //TODO: figure out if AVURLAssetPreferPreciseDurationAndTimingKey is worth it
                    // or if it will just be better to do the onliner for AVPlayer
                AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:newAssetURL options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey]];
                
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
                
                AVPlayer *newPlayer = [AVPlayer playerWithPlayerItem:playerItem];
                //Keep a pointer for easy access
                self.player = newPlayer;
                
                [self.playerView setPlayer:newPlayer];
                
                //[self addObserver:self forKeyPath:@"player.curr" options:<#(NSKeyValueObservingOptions)#> context:<#(void *)#>]
                
                self.startTimecode = CMTimecodeFromNSString(@"00:58:00:00", self.currentTrack.nominalFrameRate);
                        
                //update current track
                //[self currentTrack];
                
                if (playerTimeObserver)
                {
                    [player removeTimeObserver:playerTimeObserver]; 
                }
                
                // Build playerTimeObserver
                [self playerTimeObserver];
                
                // startTimecode.text = convertCMTimeToTimecodeString(startTime ,currentTrack.nominalFrameRate);
                
                // endTimecode.text = convertCMTimeToTimecodeString(CMTimeAdd(currentTrack.timeRange.duration, startTime) ,currentTrack.nominalFrameRate);
                
                #if DEBUG
                //DEBUG:jumping to 4min to avoid annoying beeping
                //[player seekToTime:CMTimeMakeWithSeconds(0, 1000000000) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
                #endif
                            
            }
            
        }

    }
    else
    {
        //TODO:freeup player
    }
    
}

- (void)setScrubber:(UISlider *)newScrubber
{
    if (newScrubber) {
        scrubber = newScrubber;
        
        
        [scrubber addTarget:self action:@selector(scrubberDidBegin:) forControlEvents:UIControlEventEditingDidEnd];
        [scrubber addTarget:self action:@selector(scrubberDidMove:) forControlEvents:UIControlEventValueChanged];
        [scrubber addTarget:self action:@selector(scrubberDidEnd:) forControlEvents:UIControlEventEditingDidBegin];

    }
}


#pragma mark - Getters

- (AVAssetTrack*)currentTrack
{
    
    //TODO: Sanity checking of objects
    
    AVPlayerItem *playerItem = player.currentItem;
    AVAsset * playerAsset = playerItem.asset;
    AVAssetTrack *playerAssetTrack = [[playerAsset tracksWithMediaType:AVMediaTypeVideo] lastObject];
    
    currentTrack = playerAssetTrack;
    
    return currentTrack;
    
}

- (id)playerTimeObserver
{
    if (!playerTimeObserver)
    {
        playerTimeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.f/currentTrack.nominalFrameRate, kCMTimeAccurateTimescale) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
            
            self.currentTimecode = getAssetPlayerTimecode(self.player);
            
            self.scrubber.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.currentTrack.timeRange.duration);
            
           // NSLog(@"CurrentTime:[%lld , %d]", self.player.currentTime.value, self.player.currentTime.timescale);
           // NSLog(@"StartTime:[%@]", NSStringFromCMTimecode(self.startTimecode));
            
        }];
    }
    
    return playerTimeObserver;
}

- (SBAssetPlayerV*)playerView
{
    if (!playerView) {
        playerView = [[SBAssetPlayerV alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:playerView];
        [self.view sendSubviewToBack:playerView];
    }
    
    return playerView;
}

- (CGFloat)framerate
{
    return self.currentTrack.nominalFrameRate;
}

#pragma mark - Responders

- (void)frameAdjustResponder:(id)sender
{
        
    if (self.controlsDisabled)
    {
        return;
    }
    
    if (self.player.rate > 0) {
        
        [self.player pause];
        
    }
    
    Float64 frameAdjust = 0.f;
    BOOL forward = YES;
    
    if ([sender isMemberOfClass:[UISwipeGestureRecognizer class]]) {
        
        UISwipeGestureRecognizer *senderSGR = (UISwipeGestureRecognizer*)sender;
                        
        switch ([senderSGR numberOfTouches]) {
            case 1:
                //Jump forward 1 frame
                frameAdjust = 1.f / self.currentTrack.nominalFrameRate;
                break;
            case 2:
                //Jump forward 1 sec
                frameAdjust = 1.f;
                
                break;
            case 3:
                //Jump forward 10 sec
                frameAdjust = 10.f;
                
                break;
                
            default:
                break;
        }
        
        forward = (senderSGR.direction == UISwipeGestureRecognizerDirectionLeft);
        
        
    }
    
    // TODO: Button implementation
    // Buttons based implementation is unfinished
    
    if ([sender isMemberOfClass:[UIButton class]]) {
        
        UIButton *senderButton = (UIButton*)sender;
        
        switch (senderButton.tag) {
            case FrameResponderNextFrame:
                frameAdjust = 1.f;
                break;
                
            default:
                break;
        }
        
        
    }
    
    CMTime seekTime = [player currentTime];
    
    // Possible cool trasitions between frames, but currently decoding is happening
    // in what seems to be an async fashion causing a black flash.
    
  /*  CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    */
    
    if (forward) {
        
        seekTime = CMTimeAdd(seekTime, CMTimeMakeWithSeconds(frameAdjust, self.currentTrack.naturalTimeScale));
       // [animation setSubtype:kCATransitionFromRight];

    }
    else
    {
        
        seekTime = CMTimeSubtract(seekTime, CMTimeMakeWithSeconds(frameAdjust, self.currentTrack.naturalTimeScale));
       // [animation setSubtype:kCATransitionFromLeft];

    }
        
    [player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];

    
   // [self.view.layer addAnimation:animation forKey:@"Slide"];
    
}

- (IBAction)playbackResponder:(UIGestureRecognizer*)sender
{
    
    if (self.controlsDisabled)
    {
        return;
    }
    
    //If video is currently playing
    if (self.player.rate > 0) {
        
        [self.player pause];

    }
    else
    {
        
        [self.player play];
        
    }
    
}

- (IBAction)beginRateAdjustResponder:(UIButton*)sender
{
    
    if (self.controlsDisabled)
    {
        return;
    }
    
    if (sender.tag == FrameResponderFFW) {
        [self.player setRate:2.0];
    }
    else
    if (sender.tag == FrameResponderRRW) {
        [self.player setRate:-2.0];
    }
    
}

- (IBAction)endRateAdjustResponder:(UIButton*)sender
{
    
    if (self.controlsDisabled)
    {
        return;
    }
    
    [self.player setRate:0.0];
    
}

- (void)scrubberDidBegin:(id)sender
{
    
    if (self.controlsDisabled)
    {
        return;
    }
    
    if (playerTimeObserver)
    {
        
        //playerRateStorage = [player rate];
        [self.player setRate:0.f];
        [self.player pause];
        [self.player removeTimeObserver:playerTimeObserver];
        
    }
}

- (void)scrubberDidMove:(UISlider*)slider
{
    if (self.controlsDisabled)
    {
        return;
    }
       
    CMTime seekTime = CMTimeMultiplyByFloat64(self.currentTrack.timeRange.duration, slider.value);
    
    [self.player seekToTime:seekTime];
    
    
}

- (void)scrubberDidEnd:(id)sender
{
    
    if (self.controlsDisabled)
    {
        return;
    }
    
    //[self.player setRate:playerRateStorage];
    
    //Rebuild playerTimeObserver
    [self playerTimeObserver];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Controls

- (void)pause
{
    
    [self.player pause];
    
}

- (void)jumpToAnnotation:(SBAnnotation*)annotation
{
    
    CMTimecode newTimecode = CMTimecodeFromNSString(annotation.metadata.timecode, self.currentTrack.nominalFrameRate);
    CMTime jumpTime = CMTimeFromCMTimecode(newTimecode);
    CMTimecode a = self.startTimecode;
    a.frames = 0;
    self.startTimecode = a;
    CMTime startTime = CMTimeFromCMTimecode(self.startTimecode);
    
    //NSLog(@"A: %f, B:%@", CMTimeGetSeconds(CMTimeFromCMTimecode(newTimecode)),@"");
    //NSLog(@"Start:[%f]", CMTimeGetSeconds(startTime));
    //NSLog(@"Jump:[%f]", CMTimeGetSeconds(jumpTime));
    
    CMTime newTime = CMTimeSubtract(jumpTime, CMTimeFromCMTimecode(a));
   
    //NSLog(@"Real:[%f]", CMTimeGetSeconds(newTime));

    [self pause];
    [self.player seekToTime:newTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];

}

- (UIImage*)captureFrame
{
    //Ensure it's paused
   // [self pause];
    
    AVAssetImageGenerator *assetImageGen = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.player.currentItem.asset];
    
    assetImageGen.requestedTimeToleranceBefore = kCMTimeZero;
    assetImageGen.requestedTimeToleranceAfter = kCMTimeZero;
    
    CMTime actualTime;
    NSError* error;
    
    CGImageRef cgFrame = [assetImageGen copyCGImageAtTime:self.player.currentTime actualTime:&actualTime error:&error];
    
   // NSLog(@"");
    
    //CGImageRef cgFrame = [[self.view UIImage] CGImage];
        
    if (error) NSLog(@"%@", error);
    assert(!error);
    
    return [UIImage imageWithCGImage:cgFrame];
}

@end
