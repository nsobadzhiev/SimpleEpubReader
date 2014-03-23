//
//  DMePubItemViewController.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubItemViewController.h"

@interface DMePubItemViewController ()

@end

@implementation DMePubItemViewController

- (instancetype)initWithEpubItem:(DMePubItem*)epubItem
                  andEpubManager:(DMePubManager*)epubManager
{
    self = [super initWithData:[epubManager dataForFileAtPath:epubItem.href
                                                        error:nil]];
    if (self)
    {
        self.epubItem = epubItem;
        self.epubManager = epubManager;
    }
    return self;
}

- (id)initWithData:(NSData *)htmlData
{
    self = [self initWithEpubItem:nil
                   andEpubManager:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
