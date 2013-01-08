//
//  SBAssetPlayerVC.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/18/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

#import "../Tools/CoreMedia_Timecodes.h"

#import "../Models/SBAnnotation.h"

@interface SBAssetPlayerVC : UIViewController

@property (nonatomic, strong) NSURL *assetURL;

@property (nonatomic) CMTimecode startTimecode;
@property (nonatomic, readonly) CMTimecode currentTimecode;

@property (nonatomic, assign) UISlider* scrubber;

@property (nonatomic) BOOL controlsDisabled;

@property (nonatomic, readonly) CGFloat framerate;

+ (SBAssetPlayerVC*)assetPlayerVC;

- (void)pause;

- (void)jumpToAnnotation:(SBAnnotation*)annotation;

- (UIImage*)captureFrame;

@end
