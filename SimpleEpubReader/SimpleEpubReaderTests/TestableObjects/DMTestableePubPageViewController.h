//
//  DMTestableePubPageViewController.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/2/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubPageViewController.h"
#import "DMePubItemIterator.h"

@interface DMTestableePubPageViewController : DMePubPageViewController

@property (nonatomic, readonly) DMePubItemIterator* iterator;

@end
