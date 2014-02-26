//
//  DMePubFileManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 2/24/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubFileManager.h"
#import "NSError+Description.h"

static NSString* const k_contentXmlFileName = @"/META-INF/container.xml";

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
            NSURL* fileUrl = [NSURL URLWithString:filePath];
            zipArchiver = [[ZZArchive alloc] initWithContentsOfURL:fileUrl
                                                           encoding:NSUTF8StringEncoding];
        }
    }
    return self;
}

- (NSData*)contentXmlWithError:(NSError**)error
{
    for (ZZArchiveEntry* zipEntry in zipArchiver.entries)
    {
        if ([zipEntry.fileName isEqualToString:k_contentXmlFileName])
        {
            return [zipEntry newDataWithError:error];
        }
    }
    *error = [NSError errorWithCode:1
                             domain:@"ePub read error"
                        description:@"No contents XML in ePub"];
    return nil;
}

@end
