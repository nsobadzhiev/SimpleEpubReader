//
//  DMTestableArchive.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 2/24/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTestableArchive.h"

@implementation DMTestableArchive

- (id)initWithContentsOfURL:(NSURL*)URL
				   encoding:(NSStringEncoding)encoding
{
    self = [super initWithContentsOfURL:URL
                               encoding:encoding];
	if (self)
	{
		self.wasAskedToOpenArchive = YES;
	}
	return self;
}

- (void)setFakeEntries:(NSArray*)entries
{
    fakeEntries = entries;
}

- (NSArray*)entries
{
    return fakeEntries;
}

@end
