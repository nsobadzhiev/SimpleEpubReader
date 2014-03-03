//
//  DMTestableContainerePubFileManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/3/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTestableContainerePubFileManager.h"
#import "ZZArchiveEntry+TestableContainer.h"

@implementation DMTestableContainerePubFileManager

- (NSData*)dataForZipEntry:(ZZArchiveEntry*)entry
                     error:(NSError**)error
{
    return [entry newDataWithError:error];
}

@end
