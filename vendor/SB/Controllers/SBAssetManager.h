//
//  SBAssetManager.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 12/19/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../Models/SBAnnotation.h"


// Move these strings into properties, Globals are bad.
extern NSString * const assetManagerFilesRoute;
extern NSString * const assetManagerClipRoute;
extern NSString * const assetManagerAnnotationRoute;
extern NSString * const assetManagerAnnotationsRoute;



// Completion block recieves and array of SBFileEntries
typedef void (^SBFileRequestCompletion)(NSArray *fileEntries);

typedef void (^SBAnnotationListRequestCompletion)(NSArray *annotationPrimaryKeys);
typedef void (^SBAnnotationRequestCompletion)(SBAnnotation *annotation);
typedef void (^SBAnnotationRangeRequestCompletion)(NSArray *annotations);
typedef void (^SBAnnotationPostCompletion)(SBAnnotation *annotation, NSError *error);

@interface SBAssetManager : NSObject

@property (nonatomic, strong) NSURL *apiBaseURL;

- (void)requestFilesForPath:(NSString*)path completion:(SBFileRequestCompletion)completionBlock;

- (void)requestAnnotationsForClip:(NSString*)clipPrimaryKey completion:(SBAnnotationListRequestCompletion)completionBlock;

- (void)requestAnnotationForPrimaryKey:(NSString*)primaryKey inClip:(NSString*)clipPrimaryKey completion:(SBAnnotationRequestCompletion)completionBlock;

- (void)requestAnnotationsRange:(NSRange)annotationRange inCLip:(NSString *)clipPrimaryKey completion:(SBAnnotationRangeRequestCompletion)completionBlock;

//
- (void)postAnnotation:(SBAnnotation*)annotation forClip:(NSString*)clipPrimaryKey completion:(SBAnnotationPostCompletion)completionBlock;

@end
