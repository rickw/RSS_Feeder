//
//  MTIFeedItem.h
//  RSS Feeder
//
//  Created by Rick Windham on 9/4/13.
//  Copyright (c) 2013 Rick Windham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTIFeedItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSURL *itemLink;
@property (readonly)          NSAttributedString *displayText;

+(MTIFeedItem *)itemWithTitle:(NSString *)title description:(NSString* )description andLink:(NSString *)link;

@end
