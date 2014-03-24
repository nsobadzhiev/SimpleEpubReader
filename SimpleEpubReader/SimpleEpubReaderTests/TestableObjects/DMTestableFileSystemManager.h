//
//  DMTestableFileSystemManager.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMFileSystemManager.h"

@interface DMTestableFileSystemManager : NSObject <DMFileSystemManager>

@property (nonatomic, strong) NSArray* directoryContents;
@property (nonatomic, strong) NSData* fileContents;
@property (nonatomic, strong) NSString* requestedDirPath;

@end
