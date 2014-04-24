//
//  DMePubPageViewController.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMePubManager.h"
#import "DMePubItemIterator.h"
#import "DMTableOfContentsTableViewController.h"
#import "DMBookmarkManager.h"

@interface DMePubPageViewController : UIViewController <UIPageViewControllerDataSource, DMTableOfContentsTableViewControllerDelegate>
{
    DMePubItemIterator* itemIterator;
    DMTableOfContentsTableViewController* tableOfContentsController;
    DMBookmarkManager* bookmarkManager;
}

@property (nonatomic, strong) UIPageViewController* pageViewController;
@property (nonatomic, strong) DMePubManager* epubManager;

- (instancetype)initWithEpubManager:(DMePubManager*)epubManager;

- (BOOL)loadBookmarkPosition;

@end
