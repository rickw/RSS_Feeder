//
//  RSS_FeederTests.m
//  RSS FeederTests
//
//  Created by Rick Windham on 9/4/13.
//  Copyright (c) 2013 Rick Windham. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MTIFeedItem.h"

@interface RSS_FeederTests : XCTestCase

@end

@implementation RSS_FeederTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateFeedItem
{
    MTIFeedItem *item = [MTIFeedItem itemWithTitle:@"Item Title" description:@"A Description" andLink:@"http://apple.com"];
    
    XCTAssertTrue(item, @"MTIFeedItem was not created.");
    XCTAssertTrue([item.title isEqualToString:@"Item Title"], @"Item has wrong title.");
    XCTAssertTrue([item.desc isEqualToString:@"A Description"], @"item has incorrect description.");
    XCTAssertTrue([item.itemLink.absoluteString isEqualToString:@"http://apple.com" ], @"Item Link URL incorrect.");
}


@end
