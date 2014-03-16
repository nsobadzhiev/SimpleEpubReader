//
//  DMTableOfContentsTableViewController.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/16/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMTableOfContentsTableViewController : UITableViewController
{
    NSString* epubPath;
}

- (id)initWithEpubPath:(NSString*)epubPath;

@end
