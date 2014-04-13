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
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithEpubManager:nil];
    return self;
}

- (void)setEpubManager:(DMePubManager *)epubManager
{
    if (self.epubManager != epubManager)
    {
        _epubManager = epubManager;
        itemIterator = [[DMePubItemIterator alloc] initWithEpubManager:self.epubManager];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    tableOfContentsController = [[DMTableOfContentsTableViewController alloc] initWithEpubPath:self.epubManager.epubPath];
    tableOfContentsController.delegate = self;
    [self.pageViewController setViewControllers:@[tableOfContentsController]
                                      direction:UIPageViewControllerNavigationDirectionForward 
                                       animated:YES 
                                     completion:nil];
    self.pageViewController.dataSource = self;
    [self.view addSubview:self.pageViewController.view];
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
    if ([viewController isKindOfClass:[DMePubItemViewController class]])
    {
        DMePubItemViewController* currentController = (DMePubItemViewController*)viewController;
        DMePubItem* currentItem = [itemIterator currentItem];
        DMePubItem* viewControllerItem = [currentController epubItem];
        
        if ([viewControllerItem isEqual:currentItem] == NO)
        {
            [itemIterator goToItemWithPath:viewControllerItem.href];
        }
    }
    DMePubItem* previousItem = [itemIterator previousItem];
    UIViewController* previousController = nil;
    if (previousItem == nil)
    {
        // if the begining of the book has been reached, open the table of
        // contents
        previousController = tableOfContentsController;
    }
    else
    {
        previousController = [[DMePubItemViewController alloc] initWithEpubItem:[itemIterator previousItem]
                                                                 andEpubManager:self.epubManager];
    }
    return previousController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
       viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[DMePubItemViewController class]])
    {
        DMePubItemViewController* currentController = (DMePubItemViewController*)viewController;
        DMePubItem* currentItem = [itemIterator currentItem];
        DMePubItem* viewControllerItem = [currentController epubItem];
        
        if (viewControllerItem != nil &&
            [viewControllerItem isEqual:currentItem] == NO)
        {
            [itemIterator goToItemWithPath:viewControllerItem.href];
        }
    }
    return [[DMePubItemViewController alloc] initWithEpubItem:[itemIterator nextObject]
                                               andEpubManager:self.epubManager];
}

#pragma mark - DMTableOfContentsTableViewControllerDelegate

- (void)tableOfContentsController:(DMTableOfContentsTableViewController*)tocController
            didSelectItemWithPath:(NSString*)path
{
    [itemIterator goToItemWithPath:path];
    DMePubItemViewController* selectedItemController = [[DMePubItemViewController alloc] initWithEpubItem:[itemIterator currentItem]
                                                                                           andEpubManager:self.epubManager];
    [self.pageViewController setViewControllers:@[selectedItemController]
                                      direction:UIPageViewControllerNavigationDirectionForward 
                                       animated:YES 
                                     completion:nil];
}

@end
