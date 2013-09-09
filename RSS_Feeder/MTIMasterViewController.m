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
    int _currentSelection;
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
    
    _currentSelection = -1;
    
    [_refreshControl beginRefreshing];
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentSelection == indexPath.row) {
        _currentSelection = -1;
    } else {
        _currentSelection = indexPath.row;
    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == _currentSelection) {
        return  130;
    }
    else return 60;
}

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
    MTIFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    
    MTIFeedItem *object = _objects[indexPath.row];
    cell.titleLabel.numberOfLines = 2;
    cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.titleLabel.attributedText = object.titleText;
    
    cell.descLabel.numberOfLines = 3;
    cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.descLabel.attributedText = object.descText;
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
