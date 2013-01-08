//
//  SBAsset.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/7/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBAssetMetadata.h"

#import "SBAnnotation.h"


@interface SBAsset : NSObject

@property (nonatomic, strong) SBAssetMetadata*  metadata;
@property (nonatomic, strong) NSMutableArray* annotations;

//Propogated with folders content, or possibly associated files in the future
@property (nonatomic, strong) NSMutableArray* subAssets;


+ (SBAsset*)assetWithJSONData:(NSData*)JSONData;
- (SBAsset*)initWithJSONData:(NSData*)JSONData;

@end
