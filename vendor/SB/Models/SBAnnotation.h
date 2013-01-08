//
//  SBAnnotation.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/2/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBAnnotationMetadata.h"
#import "SBAnnotationData.h"

@interface SBAnnotation : NSObject

@property (nonatomic, strong) SBAnnotationMetadata* metadata;
@property (nonatomic, strong) SBAnnotationData*     data;

#pragma mark [De]Serialization
+ (SBAnnotation*)annotationWithJSONData:(NSData*)JSONData;

- (SBAnnotation*)initWithJSONData:(NSData*)JSONData;
- (NSData*)serializeToJSONData;

@end
