//
//  SBAssetMetadata.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/7/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

//32bit integer;
typedef enum {
    
    // Main Type (first 16bits)
    SBAssetContainer = 1 << 16, //Has no data itself, ie. folder
    SBAssetMedia = 1 << 15,
    
    // Specific Type (last 16bits)
    SBAssetNone = 0,
    SBAssetFolder = SBAssetContainer | SBAssetNone,
    SBAssetVideo  = SBAssetMedia | 1 << 1,
    SBAssetImage  = SBAssetMedia | 1 << 2,
    SBAssetPDF    = SBAssetMedia | 1 << 3,
    SBAssetAudio  = SBAssetMedia | 1 << 4
    
}SBAssetType;

@interface SBAssetMetadata : NSObject

#pragma mark Required data
@property (nonatomic, strong) NSString*     key;
@property (nonatomic, strong) NSString*     creationDate;
@property (nonatomic)         SBAssetType   type;
@property (nonatomic, strong) NSString*     name;
@property (nonatomic)         BOOL          owner;
@property (nonatomic)         BOOL          locked;
@property (nonatomic)         BOOL          final;

@property (nonatomic, strong) NSString* startTimecode;
@property (nonatomic, strong) NSString* url;


#pragma mark Optional data
@property (nonatomic, strong) NSString* lastEditDate;
@property (nonatomic, strong) NSString* lastEditor;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSData*   preview; // Image

@end
