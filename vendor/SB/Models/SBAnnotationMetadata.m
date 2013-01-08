//
//  SBAnnotationMetadata.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/2/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "SBAnnotationMetadata.h"

@implementation SBAnnotationMetadata

#pragma mark Organizational Data
@synthesize key;
@synthesize author;
@synthesize categories;

#pragma mark Immutable Data
@synthesize timecode;
@synthesize frame;
@synthesize frameThumbnail;

#pragma mark - Setters

- (void)setValue:(id)value forKey:(NSString *)aKey
{
    
    if ([value isKindOfClass:[NSArray class]] && [aKey isEqualToString:@"categories"])
    {
        [self.categories addObjectsFromArray:(NSArray*)value];
    }
    else
    {
        [super setValue:value forKey:aKey];
    }
}

#pragma mark - Getters

- (NSMutableArray*)categories
{
    if (!categories)
    {
        categories = [NSMutableArray array];
    }
    
    return categories;
}

@end
