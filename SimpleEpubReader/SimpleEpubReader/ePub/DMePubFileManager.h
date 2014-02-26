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

- (id)init;
- (id)initWithEpubPath:(NSString*)filePath;

- (NSData*)contentXmlWithError:(NSError**)error;

@end
