//
//  DMePubPageViewController.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubPageViewController.h"
#import "DMePubItemViewController.h"

@interface DMePubPageViewController ()

@end

@implementation DMePubPageViewController

- (instancetype)initWithEpubManager:(DMePubManager*)epubManager
{
    self = [super initWithNibName:nil
                           bundle:nil];
    if (self)
    {
        self.epubManager = epubManager;
        itemIterator = [[DMePubItemIterator alloc] initWithEpubManager:self.epubManager];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithEpubManager:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewController

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    DMePubItemViewController* currentController = (DMePubItemViewController*)viewController;
    DMePubItem* currentItem = [itemIterator currentItem];
    DMePubItem* viewControllerItem = [currentController epubItem];
    
    if ([viewControllerItem isEqual:currentItem] == NO)
    {
        [itemIterator goToItemWithPath:viewControllerItem.href];
    }
    
    return [[DMePubItemViewController alloc] initWithEpubItem:[itemIterator previousItem]
                                               andEpubManager:self.epubManager];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
       viewControllerAfterViewController:(UIViewController *)viewController
{
    DMePubItemViewController* currentController = (DMePubItemViewController*)viewController;
    DMePubItem* currentItem = [itemIterator currentItem];
    DMePubItem* viewControllerItem = [currentController epubItem];
    
    if ([viewControllerItem isEqual:currentItem] == NO)
    {
        [itemIterator goToItemWithPath:viewControllerItem.href];
    }

    return [[DMePubItemViewController alloc] initWithEpubItem:[itemIterator nextObject]
                                               andEpubManager:self.epubManager];
}

@end
