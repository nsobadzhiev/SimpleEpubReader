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

// The testable zip archive will only return it's hardcoded entries provided
// that it was created to the right zipLocation or the zipLocation is nil.
@property (nonatomic, strong) NSString* zipLocation;
@property (nonatomic, strong) NSString* openedLocation;

- (void)setFakeEntries:(NSArray*)entries;

@end
