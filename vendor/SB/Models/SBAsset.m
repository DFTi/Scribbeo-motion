//
//  SBAsset.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/7/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "SBAsset.h"

// #import "NSArray+Access.h"
// #import "NSObject+ZTAdditions.h"

@interface SBAsset ()

@end

@implementation SBAsset

#pragma mark Private Properties

@synthesize annotations;
@synthesize subAssets;

#pragma mark Public Properties

@synthesize metadata;

#pragma mark - lifecycle

+ (SBAsset*)assetWithJSONData:(NSData*)JSONData
{
    return [[SBAsset alloc] initWithJSONData:JSONData];
}


- (SBAsset*)initWithJSONData:(NSData*)JSONData{
    self = [[SBAsset alloc] init];
    if (self)
    {
        //Initialize members
        [self metadata];
        [self annotations];
        
        NSError* error;
        
        
        NSMutableDictionary* JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:&error];
        
        if (error) {
            NSLog(@"%@", error.description);
        }
        assert(!error);
        
        [self setValuesForKeysWithDictionary:JSONDictionary];
    }
    
    return self;
}


#pragma mark - Setters

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"data"] && [value isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *asset in value) {
            if([asset isKindOfClass:[NSDictionary class]])
            {
                SBAsset* newSubAsset = [[SBAsset alloc] init];
                [newSubAsset setValuesForKeysWithDictionary:asset];
                
                [self.subAssets addObject:newSubAsset];
            }
        }
    }
    else if ([key isEqualToString:@"metadata"] && [value isKindOfClass:[NSDictionary class]])
    {
        [self.metadata setValuesForKeysWithDictionary:value];
    }
    else if ([key isEqualToString:@"annotations"] && [value isKindOfClass:[NSArray class]]){
               
        for (NSDictionary *annotation in value)
        {
            SBAnnotation* newAnnotation = [[SBAnnotation alloc] init];
            [newAnnotation setValuesForKeysWithDictionary:annotation];
            
            [self.annotations addObject:newAnnotation];
        }
    
    }
    else {
        [super setValue:value forKey:key];
    }
}

#pragma mark - Getters

- (id)valueForKey:(NSString *)key
{
    if ([key isEqualToString:@"metadata"])
    {
        return [self.metadata dictionaryValue];
    }
    else
    {
        return [super valueForKey:key];
    }
}

- (SBAssetMetadata*)metadata
{
    if (!metadata) {
        metadata = [[SBAssetMetadata alloc] init];
    }
    
    return metadata;
}

- (NSMutableArray*)annotations
{
    if (!annotations) {
        annotations = [NSMutableArray array];
    }
    
    return annotations;
}

- (NSMutableArray*)subAssets
{
    if (!subAssets) {
        subAssets = [NSMutableArray array];
    }
    
    return subAssets;
}
@end
