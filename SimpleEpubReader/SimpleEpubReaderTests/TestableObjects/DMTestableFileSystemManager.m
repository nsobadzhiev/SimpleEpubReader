//
//  DMTestableFileSystemManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTestableFileSystemManager.h"

@implementation DMTestableFileSystemManager

- (NSArray*)contentsOfDirectoryAtPath:(NSString*)path 
                                error:(NSError**)error
{
    self.requestedDirPath = path;
    return self.directoryContents;
}

- (NSData*)contentsAtPath:(NSString*)path
{
    return self.fileContents;
}

@end
