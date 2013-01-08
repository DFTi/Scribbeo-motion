//
//  SBFileEntry.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 12/19/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "SBFileEntry.h"

NSString * const SBFileEntryKeyName = @"name";
NSString * const SBFileEntryKeyType = @"type";
NSString * const SBFileEntryKeyPrimaryKey = @"primary_key";

NSString * const SBFileEntryTypeFolder = @"folder";
NSString * const SBFileEntryTypeClip = @"clip";
NSString * const SBFileEntryTypeStill = @"still";
NSString * const SBFileEntryTypeAudio = @"audio";
NSString * const SBFileEntryTypeText = @"text";

@interface SBFileEntry ()

@property (strong, readwrite) NSString *name;
@property (strong, readwrite) NSString *type;
@property (strong, readwrite) NSString *primaryKey;

@end

@implementation SBFileEntry

@synthesize name;
@synthesize type;
@synthesize primaryKey;

- (id)init
{
    
    self = [super init];
    if (!self)
    {

    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)aDictionary
{
    
    id fileEntry = [self init];
    
    self.name = [aDictionary objectForKey:SBFileEntryKeyName];
    self.type = [aDictionary objectForKey:SBFileEntryKeyType];
    self.primaryKey = [aDictionary objectForKey:SBFileEntryKeyPrimaryKey];
    
    return fileEntry;
}

+ (id)fileEntryWithDictionary:(NSDictionary*)aDictionary
{
    
    return [[SBFileEntry alloc] initWithDictionary:aDictionary];
    
}

- (NSDictionary*)dictionaryRepresentation
{
    
    NSMutableDictionary *representation = [NSMutableDictionary dictionary];
    
    [representation setObject:self.name forKey:SBFileEntryKeyName];
    [representation setObject:self.type forKey:SBFileEntryKeyType];
    [representation setObject:self.primaryKey forKey:SBFileEntryKeyPrimaryKey];
    
    return representation;
}


@end
