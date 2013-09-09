//
//  MTIFeedItem.m
//  RSS Feeder
//
//  Created by Rick Windham on 9/4/13.
//  Copyright (c) 2013 Rick Windham. All rights reserved.
//

#import "MTIFeedItem.h"

@implementation MTIFeedItem

+ (MTIFeedItem *)itemWithTitle:(NSString *)title description:(NSString* )description andLink:(NSString *)link
{
    MTIFeedItem *newItem = [[MTIFeedItem alloc] init];
    
    newItem.title = title;
    newItem.desc = description;
    newItem.itemLink = [NSURL URLWithString:link];
    
    return newItem;
}

- (NSAttributedString *)titleText
{
    return [[NSAttributedString alloc] initWithString:_title
                                           attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}];
}

- (NSAttributedString *)descText
{
    return [[NSAttributedString alloc] initWithString:_desc
                                           attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]}];
            
}

@end
