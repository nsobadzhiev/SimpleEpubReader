//
//  DMBookmark.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMBookmark.h"

static NSString* const k_fileNameEncodingKey = @"bookmarkFileName";
static NSString* const k_fileSectionEncodingKey = @"bookmarkFileSection";
static NSString* const k_filePositionEncodingKey = @"bookmarkFilePosition";

@implementation DMBookmark

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.fileName = [aDecoder decodeObjectForKey:k_fileNameEncodingKey];
        self.fileSection = [aDecoder decodeObjectForKey:k_fileSectionEncodingKey];
        self.filePosition = [aDecoder decodeObjectForKey:k_filePositionEncodingKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fileName forKey:k_fileNameEncodingKey];
    [aCoder encodeObject:self.fileSection forKey:k_fileSectionEncodingKey];
    [aCoder encodeObject:self.filePosition forKey:k_filePositionEncodingKey];
}

@end
