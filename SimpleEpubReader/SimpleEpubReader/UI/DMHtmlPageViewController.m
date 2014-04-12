//
//  DMHtmlPageViewController.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/17/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMHtmlPageViewController.h"

@interface DMHtmlPageViewController ()

@end

@implementation DMHtmlPageViewController

- (instancetype)initWithData:(NSData *)_htmlData
{
    self = [super initWithNibName:@"DMHtmlPageViewController"
                           bundle:nil];
    if (self)
    {
        htmlData = _htmlData;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithData:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIWebView* webView = (UIWebView*)self.view;
    NSString* epubPath = [NSString stringWithFormat:@"%@%@/", @"epub:/", self.filePath];
    epubPath = [epubPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [webView setScalesPageToFit:YES];
    [webView loadData:htmlData
             MIMEType:@"application/xhtml+xml"
     textEncodingName:@"utf-8"
              baseURL:[NSURL URLWithString:epubPath]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType
{
    // TODO: if it is a request for external resource,
    // open it outside the book (maybe in safari)
    return YES;
}

@end
