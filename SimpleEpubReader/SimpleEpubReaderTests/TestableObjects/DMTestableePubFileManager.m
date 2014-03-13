//
//  DMTestableePubFileManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 2/24/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTestableePubFileManager.h"

@implementation DMTestableePubFileManager

- (id)initWithArchiverClass:(Class)archiveClass
{
    self = [super initWithEpubPath:@""];
    if (self)
    {
        self.archiver = [[archiveClass alloc] initWithContentsOfURL:nil
                                                           encoding:NSUTF8StringEncoding];
    }
    return self;
}

- (ZZArchive*)zipArchiver
{
    return zipArchiver;
}

- (void)setArchiver:(ZZArchive *)archiver
{
    zipArchiver = archiver;
    _archiver = archiver;
}

- (NSData*)dataForZipEntry:(ZZArchiveEntry*)entry
                     error:(NSError**)error
{
    if (self.hardcodedZipData != nil)
    {
        return self.hardcodedZipData;
    }
    else
    {
        return [entry newDataWithError:error];
    }
}

- (NSData*)contentXmlWithName:zipContentsName
                        error:(NSError**)error
{
    if (self.hardcodedZipData != nil)
    {
        return self.hardcodedZipData;
    }
    else
    {
        return [super contentXmlWithName:zipContentsName
                                   error:error];
    }
}

@end
