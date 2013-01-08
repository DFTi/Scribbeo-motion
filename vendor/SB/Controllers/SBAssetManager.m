//
//  SBAssetManager.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 12/19/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "SBAssetManager.h"
#import "../Models/SBFileEntry.h"

NSString * const assetManagerFilesRoute = @"files";
NSString * const assetManagerClipRoute = @"clip";
NSString * const assetManagerAnnotationRoute = @"annotation";
NSString * const assetManagerAnnotationsRoute = @"annotations";


@interface SBAssetManager ()

@property (nonatomic, strong) NSCache *fileEntryCache;

@end

@implementation SBAssetManager

@synthesize fileEntryCache;

@synthesize apiBaseURL;

#pragma mark - Files

- (void)requestFilesForPath:(NSString*)path completion:(SBFileRequestCompletion)completionBlock
{
    
   /*  
    
    TODO:decide on caching policy
    
    Is caching the right thing to do? What if the filesystem changed since cache?
    
    NSArray *cachedFileEntries = [self.fileEntryCache objectForKey:path];
    
    if (cachedFileEntries) {
        completionBlock(cachedFileEntries);
        return;
    }
    */
    
    NSString *filesPath = [assetManagerFilesRoute stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:filesPath relativeToURL:self.apiBaseURL];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPShouldHandleCookies:YES];//Handle session cookie data
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
    
        //TODO: Error handling/checking
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *fileEntries = [jsonResponse objectForKey:assetManagerFilesRoute];
        NSMutableArray *fileEntryObjects = [NSMutableArray array];
        
        for (NSDictionary *fileEntry in fileEntries) {
        
            SBFileEntry *fileEntryObject = [SBFileEntry fileEntryWithDictionary:fileEntry];
            [fileEntryObjects addObject:fileEntryObject];
            
        }
                
        //Cache data
        [self.fileEntryCache setObject:fileEntryObjects forKey:path];
        
        //Feed our data to the callback
        completionBlock(fileEntryObjects);
        
    }];

}

#pragma mark - Annotations

- (void)requestAnnotationsForClip:(NSString*)clipPrimaryKey completion:(SBAnnotationListRequestCompletion)completionBlock
{
    NSString *clipsPath = [assetManagerClipRoute stringByAppendingPathComponent:clipPrimaryKey];
    NSString *annotationsPath = [clipsPath stringByAppendingPathComponent:assetManagerAnnotationsRoute];
    NSURL *url = [NSURL URLWithString:annotationsPath relativeToURL:self.apiBaseURL];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPShouldHandleCookies:YES];//Handle session cookie data
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
        
        //TODO: Error handling/checking
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *annotationsList = [jsonResponse objectForKey:assetManagerAnnotationsRoute];
        
        //Feed our data to the callback
        completionBlock(annotationsList);
        
    }];
}


- (void)requestAnnotationForPrimaryKey:(NSString*)primaryKey inClip:(NSString*)clipPrimaryKey completion:(SBAnnotationRequestCompletion)completionBlock
{
    
    NSString *clipsPath = [assetManagerClipRoute stringByAppendingPathComponent:clipPrimaryKey];
    NSString *annotationsPath = [clipsPath stringByAppendingPathComponent:assetManagerAnnotationsRoute];
    NSString *annotationPath = [annotationsPath stringByAppendingPathComponent:clipPrimaryKey];
    NSURL *url = [NSURL URLWithString:annotationPath relativeToURL:self.apiBaseURL];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPShouldHandleCookies:YES];//Handle session cookie data
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
        
        //TODO: Error handling/checking
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *annotation = [jsonResponse objectForKey:assetManagerAnnotationsRoute];
        SBAnnotation *annotationObject = [SBAnnotation annotationWithDictionary:annotation];
        
        //Feed our data to the callback
        completionBlock(annotationObject);
        
    }];
    
}

- (void)requestAnnotationsRange:(NSRange)annotationRange inCLip:(NSString *)clipPrimaryKey completion:(SBAnnotationRangeRequestCompletion)completionBlock
{
    
    NSString *clipsPath = [assetManagerClipRoute stringByAppendingPathComponent:clipPrimaryKey];
    NSString *annotationsPath = [clipsPath stringByAppendingPathComponent:assetManagerAnnotationsRoute];
    NSString *annotationRangeString = [NSString stringWithFormat:@"?s=%@&e=%@", annotationRange.location, annotationRange.location + annotationRange.length];
    NSString *annotationPath = [annotationsPath stringByAppendingPathComponent:clipPrimaryKey];
    NSString *annotationsPathRange = [annotationPath stringByAppendingString:annotationRangeString];
    NSURL *url = [NSURL URLWithString:annotationsPathRange relativeToURL:self.apiBaseURL];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPShouldHandleCookies:YES];//Handle session cookie data
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
        
        //TODO: Error handling/checking
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *annotations = [jsonResponse objectForKey:assetManagerAnnotationsRoute];
        
        NSMutableArray *annotationList = [NSMutableArray array];
        
        for (NSDictionary *annotation in annotations) {
            SBAnnotation *annotationObject = [SBAnnotation annotationWithDictionary:annotation];
            [annotationList addObject:annotationObject];
        }
        
        //Feed our data to the callback
        completionBlock(annotationList);
        
    }];
    
}

- (NSCache*)fileEntryCache
{
    
    if (!fileEntryCache) {
        fileEntryCache = [[NSCache alloc] init];
        [fileEntryCache setName:@"fileEntryCache"];
    }
    
    return fileEntryCache;
    
}

@end
