//
//  SBFileEntry.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 12/19/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SBFileEntryKeyName;
extern NSString * const SBFileEntryKeyType;
extern NSString * const SBFileEntryKeyPrimaryKey;

extern NSString * const SBFileEntryTypeFolder;
extern NSString * const SBFileEntryTypeClip;
extern NSString * const SBFileEntryTypeStill;
extern NSString * const SBFileEntryTypeAudio;
extern NSString * const SBFileEntryTypeText;



@interface SBFileEntry : NSObject

@property (strong, readonly) NSString *name;
@property (strong, readonly) NSString *type;
@property (strong, readonly) NSString *primaryKey;

+ (id)fileEntryWithDictionary:(NSDictionary*)aDictionary;
- (id)initWithDictionary:(NSDictionary*)aDictionary;

- (NSDictionary*)dictionaryRepresentation;

@end
