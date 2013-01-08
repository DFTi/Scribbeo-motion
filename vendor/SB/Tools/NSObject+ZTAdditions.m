//
//  NSObject+ZTAdditions.m
//  ZTKit
//
//  Created by Zachry Thayer on 3/7/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "NSObject+ZTAdditions.h"

#import <objc/message.h>

@implementation NSObject (ZTAdditions)

- (NSDictionary*)dictionaryValue
{
    return [self dictionaryWithValuesForKeys:[self allPropertyKeys]];
}

- (NSArray*)allPropertyKeys
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    return propertyNames;
}

@end
