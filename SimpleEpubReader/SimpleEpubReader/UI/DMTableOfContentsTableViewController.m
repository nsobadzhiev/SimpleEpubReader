//
//  DMTableOfContentsTableViewController.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/16/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTableOfContentsTableViewController.h"
#import "DMTableOfContentsDataSource.h"

@interface DMTableOfContentsTableViewController ()

@end

@implementation DMTableOfContentsTableViewController

- (id)initWithEpubPath:(NSString*)_epubPath
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        epubPath = _epubPath;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self initWithEpubPath:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DMTableOfContentsDataSource* tocDataSource = [[DMTableOfContentsDataSource alloc] initWithEpubPath:epubPath];
    self.tableView.dataSource = tocDataSource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
