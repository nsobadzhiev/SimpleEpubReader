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
            [self openEpubWithPath:filePath];
        }
    }
    return self;
}

- (void)openEpubWithPath:(NSString*)path
{
    if (path.length <= 0)
    {
        return;
    }
    
    NSURL* fileUrl = [[NSURL alloc] initFileURLWithPath:path
                                            isDirectory:NO];
    Class zipClass = [zipArchiver class];
    zipArchiver = [zipClass archiveWithContentsOfURL:fileUrl];
}

- (BOOL)fileOpen
{
    return (zipArchiver.entries != nil);
}

- (NSData*)contentXmlWithName:(NSString*)zipContentsName
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
