//
//  DMePubFileManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 2/24/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubFileManager.h"
#import "NSError+Description.h"

static NSString* const k_containerXmlFileName = @"META-INF/container.xml";

@implementation DMePubFileManager

- (id)init
{
    self = [super init];
    if (self)
    {
        zipArchiver = nil;
    }
    return self;
}

- (id)initWithEpubPath:(NSString*)filePath
{
    self = [self init];
    if (self)
    {
        if (filePath != nil)
        {
            NSURL* fileUrl = [[NSURL alloc] initFileURLWithPath:filePath
                                                    isDirectory:NO];
            zipArchiver = [[ZZArchive alloc] initWithContentsOfURL:fileUrl
                                                           encoding:NSUTF8StringEncoding];
        }
    }
    return self;
}

- (NSData*)contentXmlWithName:zipContentsName
                        error:(NSError**)error
{
    for (ZZArchiveEntry* zipEntry in zipArchiver.entries)
    {
        if ([zipEntry.fileName isEqualToString:zipContentsName])
        {
            return [zipEntry newDataWithError:error];
        }
    }
    if (error != nil)
    {
        *error = [NSError errorWithCode:1
                                 domain:@"ePub read error"
                            description:@"No contents XML in ePub"];
    }
    return nil;
}

- (NSData*)containerXmlWithError:(NSError**)error
{
    return [self contentXmlWithName:k_containerXmlFileName
                              error:error];
}

@end
