//
//  DMTestableArchive.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 2/24/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <zipzap/zipzap.h>

@interface DMTestableArchive : ZZArchive
{
    NSArray* fakeEntries;
}

@property (nonatomic) BOOL wasAskedToOpenArchive;

- (void)setFakeEntries:(NSArray*)entries;

@end
