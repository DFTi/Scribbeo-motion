//
//  SBAssetPlayerV.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/28/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface SBAssetPlayerV : UIView

- (AVPlayer*)player;
- (void)setPlayer:(AVPlayer *)aplayer;

@end
