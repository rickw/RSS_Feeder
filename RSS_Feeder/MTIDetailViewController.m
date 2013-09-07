//
//  MTIDetailViewController.m
//  RSS Feeder
//
//  Created by Rick Windham on 9/4/13.
//  Copyright (c) 2013 Rick Windham. All rights reserved.
//

#import "MTIDetailViewController.h"


@interface MTIDetailViewController ()
- (void)configureView;
@end

@implementation MTIDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(MTIFeedItem *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:_detailItem.itemLink];
        _webView.backgroundColor = [UIColor clearColor];
        [_webView loadRequest:request];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
