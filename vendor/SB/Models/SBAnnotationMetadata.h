//
//  SBAnnotationMetadata.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/2/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBAnnotationMetadata : NSObject

#pragma mark Organizational Data
@property (nonatomic, strong) NSString*        key;
@property (nonatomic, strong) NSString*        author;
@property (nonatomic, strong) NSMutableArray*  categories;

#pragma mark Immutable Data
@property (nonatomic, strong) NSString* timecode;
@property (nonatomic, strong) NSData*   frame;
@property (nonatomic, strong) NSData*   frameThumbnail;

@end
