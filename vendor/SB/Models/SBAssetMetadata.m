//
//  SBAssetMetadata.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/7/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "SBAssetMetadata.h"
// #import "NSData+Additions.h"

@implementation SBAssetMetadata

#pragma mark Required data
@synthesize key;
@synthesize creationDate;
@synthesize type;
@synthesize name;
@synthesize owner;
@synthesize locked;
@synthesize final;

@synthesize startTimecode;
@synthesize url;

#pragma mark Optional data
@synthesize lastEditDate;
@synthesize lastEditor;
@synthesize description;
@synthesize preview;


#pragma mark - Setters

- (void)setValue:(id)value forKey:(NSString *)aKey
{
    
    if ([aKey isEqualToString:@"type"])
    {
        [self setType:[value integerValue]];
    }
    else if ([aKey isEqualToString:@"owner"])
    {
        [self setOwner:[value boolValue]];
    }
    else if ([aKey isEqualToString:@"locked"])
    {
        [self setLocked:[value boolValue]];
    }
    else if ([aKey isEqualToString:@"final"])
    {
        [self setFinal:[value boolValue]];
    }
    else if ([aKey isEqualToString:@"preview"])
    {
        [self setPreview:[NSData dataWithBase64EncodedString:value]];
    }
    else
    {
        [super setValue:value forKey:aKey];
    }
}


@end
