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

@interface DMePubPageViewController : UIViewController <UIPageViewControllerDataSource>
{
    DMePubItemIterator* itemIterator;
}

@property (nonatomic, strong) UIPageViewController* pageViewController;
@property (nonatomic, strong) DMePubManager* epubManager;

- (instancetype)initWithEpubManager:(DMePubManager*)epubManager;

@end
