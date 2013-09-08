//
//  MTIMasterViewController.m
//  RSS Feeder
//
//  Created by Rick Windham on 9/4/13.
//  Copyright (c) 2013 Rick Windham. All rights reserved.
//

#import "MTIMasterViewController.h"

#import "MTIDetailViewController.h"

#import "RXMLElement.h"
#import "MTIFeedItem.h"
#import "MTIFeedCell.h"

typedef void (^MTIFeedCompleationBlock)(NSString *feed, NSArray *items);

@interface MTIMasterViewController () {
    NSArray *_objects;
    NSURL *_url;
    UIRefreshControl *_refreshControl;
}
@end

@implementation MTIMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // refresh control
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"loading..."
                                                                      attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}];
    [_refreshControl addTarget:self action:@selector(refreshInvoked:forState:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];
    
    _url = [NSURL URLWithString:@"http://feeds.reuters.com/reuters/technologyNews"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshInvoked:_refreshControl forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Additions
- (void)refreshInvoked:(id)sender forState:(UIControlState)state
{
    [self getFeedWithURL:_url complationBlock:^(NSString *feed, NSArray *items) {
        
        _objects = items;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_refreshControl endRefreshing];
            [self.tableView reloadData];
        });
    }];
}

- (void)getFeedWithURL:(NSURL *)url complationBlock:(MTIFeedCompleationBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RXMLElement *feed = [RXMLElement elementFromURL:url];
        RXMLElement *title = [[feed child:@"channel"] child:@"title"];
        NSArray *items =[[feed child:@"channel"] children:@"item"];
        
        NSMutableArray *itemArray = [NSMutableArray array];
        
        for (RXMLElement *i in items) {
            [itemArray addObject:[MTIFeedItem itemWithTitle:[[i child:@"title"] text]
                                                description:[[i child:@"description"] text]
                                                    andLink:[[i child:@"link"] text]]];
        }
        
        block(title.text, itemArray);
    });
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTIFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    MTIFeedItem *object = _objects[indexPath.row];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.attributedText = object.displayText;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MTIFeedItem *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
