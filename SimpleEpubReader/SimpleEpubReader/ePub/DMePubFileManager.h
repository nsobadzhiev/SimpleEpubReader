//
//  DMePubFileManager.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 2/24/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <zipzap/zipzap.h>

@interface DMePubFileManager : NSObject
{
    ZZArchive* zipArchiver;
}

@property (nonatomic, readonly) BOOL fileOpen;

- (id)init;
- (id)initWithEpubPath:(NSString*)filePath;

- (void)openEpubWithPath:(NSString*)path;

- (NSData*)contentXmlWithName:zipContentsName
                        error:(NSError**)error;
- (NSData*)containerXmlWithError:(NSError**)error;

@end
