//
//  ZZArchiveEntry+TestableContainer.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/3/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <zipzap/zipzap.h>

@interface ZZArchiveEntry (TestableContainer)

- (NSData*)newDataWithError:(NSError**)error;

@end
