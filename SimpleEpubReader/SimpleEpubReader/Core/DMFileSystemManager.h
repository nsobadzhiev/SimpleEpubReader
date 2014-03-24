//
//  DMFileSystemManager.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DMFileSystemManager <NSObject>

@required

- (NSArray*)contentsOfDirectoryAtPath:(NSString*)path 
                                error:(NSError**)error;
- (NSData*)contentsAtPath:(NSString*)path;

@end
