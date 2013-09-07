//
//  MTIDetailViewController.h
//  RSS Feeder
//
//  Created by Rick Windham on 9/4/13.
//  Copyright (c) 2013 Rick Windham. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTIFeedItem.h"

@interface MTIDetailViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) MTIFeedItem *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
