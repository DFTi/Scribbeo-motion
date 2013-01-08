//
//  SBAnnotationData.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/2/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "SBAnnotation.h"

// #import "NSData+Additions.h"
// #import "NSObject+ZTAdditions.h"

@implementation SBAnnotation

@synthesize metadata;
@synthesize data;

#pragma mark [De]Serialization

+ (SBAnnotation*)annotationWithJSONData:(NSData*)JSONData
{
    return [[SBAnnotation alloc] initWithJSONData:JSONData];
}

- (SBAnnotation*)initWithJSONData:(NSData*)JSONData
{
    self = [super init];
    if (self)
    {
        
        //Initialize members
        [self metadata];
        [self data];
        
        NSError* error;
        
        NSMutableDictionary* JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:&error];
        
        assert(!error);
                
        [self setValuesForKeysWithDictionary:JSONDictionary];
    }
    
    return self;
}

- (NSData*)serializeToJSONData
{
    //TODO:
    
    NSDictionary* allValues = [self dictionaryValue];
    
    NSError* error;
    NSData* JSONData = [NSJSONSerialization dataWithJSONObject:allValues options:0 error:&error]; 
        
    assert(!error);

    return JSONData;
}

#pragma mark - Setters

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"metadata"] && [value isKindOfClass:[NSDictionary class]])
    {
        [self.metadata setValuesForKeysWithDictionary:value];
    }
    else if ([key isEqualToString:@"data"] && [value isKindOfClass:[NSDictionary class]]){
        [self.data setValuesForKeysWithDictionary:value];
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
    else if ([key isEqualToString:@"data"])
    {
        return [self.data dictionaryValue];
    }
    else
    {
        return [super valueForKey:key];
    }
}

- (SBAnnotationMetadata*)metadata
{
    if (!metadata) 
    {
        metadata = [[SBAnnotationMetadata alloc] init];
    }
    
    return metadata;
}

- (SBAnnotationData*)data
{
    if (!data) 
    {
        data = [[SBAnnotationData alloc] init];
    }
    
    return data;
}

@end
