//
//  DMTableOfContentsDataSource.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/14/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTableOfContentsDataSource.h"

@interface DMTableOfContentsDataSource ()

- (DMePubManager*)createEpubManagerWithPath:(NSString*)path;

@end

@implementation DMTableOfContentsDataSource

- (instancetype)initWithEpubPath:(NSString*)path
{
    self = [super init];
    if (self)
    {
        epubManager = [self createEpubManagerWithPath:path];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithEpubPath:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[epubManager allNavigationItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* const cellReuseId = @"TOC cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellReuseId];
    }
    NSArray* tocItems = [epubManager allNavigationItems];
    DMTableOfContentsItem* tocItem = [tocItems objectAtIndex:indexPath.row];
    cell.textLabel.text = tocItem.name;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark PrivateMethods

- (DMePubManager*)createEpubManagerWithPath:(NSString*)path
{
    return [[DMePubManager alloc] initWithEpubPath:path];
}

@end
