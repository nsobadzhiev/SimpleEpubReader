//
//  DMTestableArchive.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 2/24/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTestableArchive.h"

static NSString* expectedZipLocation = nil;

@implementation DMTestableArchive

- (id)initWithContentsOfURL:(NSURL*)URL
				   encoding:(NSStringEncoding)encoding
{
    self = [super initWithContentsOfURL:URL
                               encoding:encoding];
	if (self)
	{
		self.wasAskedToOpenArchive = YES;
        self.openedLocation = [URL path];
        self.fakeEntries = [NSArray array];
	}
	return self;
}

- (void)setZipLocation:(NSString *)zipLocation
{
    expectedZipLocation = zipLocation;
}

- (void)setFakeEntries:(NSArray*)entries
{
    fakeEntries = entries;
}

- (NSArray*)entries
{
    if (expectedZipLocation == nil ||
        [expectedZipLocation isEqualToString:self.openedLocation])
    {
        return fakeEntries;
    }
    else
    {
        return nil;
    }
}

@end
