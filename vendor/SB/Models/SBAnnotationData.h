//
//  SBAnnotationData.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/2/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBAnnotationData : NSObject

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSString* drawing;
@property (nonatomic, strong) NSData*   audio;

@end
