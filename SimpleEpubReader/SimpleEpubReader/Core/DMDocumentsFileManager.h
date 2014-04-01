//
//  DMDocumentsFileManager.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMFileSystemManager.h"

@interface DMDocumentsFileManager : NSObject

@property (nonatomic, strong) id<DMFileSystemManager> fileSystemManager;

- (NSArray*)allDocuments;
- (NSArray*)allDocumentPaths;
- (NSData*)contentsOfFile:(NSString*)filePath;

@end
