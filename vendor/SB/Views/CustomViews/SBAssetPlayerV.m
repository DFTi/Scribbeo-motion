//
//  SBAssetPlayerV.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/28/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "SBAssetPlayerV.h"

@implementation SBAssetPlayerV

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)aplayer {
    [(AVPlayerLayer *)[self layer] setPlayer:aplayer];
}


@end
