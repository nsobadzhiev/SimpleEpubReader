//
//  DMDocumentsFileManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMDocumentsFileManager.h"

@implementation DMDocumentsFileManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.fileSystemManager = (id<DMFileSystemManager>)[NSFileManager defaultManager];
    }
    return self;
}

- (NSArray*)allDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    return [self.fileSystemManager contentsOfDirectoryAtPath:documentsDirectory
                                                       error:nil];
}

- (NSArray*)allDocumentPaths
{
    NSArray* allFileNames = [self allDocuments];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableArray* allPaths = [NSMutableArray arrayWithCapacity:allFileNames.count];
    for (NSString* fileName in allFileNames)
    {
        NSString* filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        [allPaths addObject:filePath];
    }
    return [NSArray arrayWithArray:allPaths];
}

- (NSData*)contentsOfFile:(NSString*)filePath
{
    return [self.fileSystemManager contentsAtPath:filePath];
}

@end
