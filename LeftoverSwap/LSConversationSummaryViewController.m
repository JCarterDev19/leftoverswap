//
//  LSConversationSummaryViewController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/9/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSConversationSummaryViewController.h"
#import "LSConversationSummaryCell.h"
#import "LSConstants.h"

@interface LSConversationSummaryViewController ()

@end

@implementation LSConversationSummaryViewController

#pragma mark - UIViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Conversations" image:nil tag:0];
    
    // The className to query on
    self.parseClassName = kConversationClassKey;
    
    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = NO;
    
    // Whether the built-in pagination is enabled
    self.paginationEnabled = NO;
    
    // The number of objects to show per page
    self.objectsPerPage = 15;
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row < self.objects.count) {
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    PFUser *user = (PFUser*)[object objectForKey:kConversationFromUserKey];
    NSString *nameString = @"";
    
    if (user) {
      nameString = [user objectForKey:kUserDisplayNameKey];
    }
    
    return 44;//[LSConversationSummaryCell heightForCellWithName:nameString contentString:activityString];
  } else {
    return 44;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.row < self.objects.count) {
    //    PFObject *activity = [self.objects objectAtIndex:indexPath.row];
    //        if ([activity objectForKey:kPAPActivityPhotoKey]) {
    //            PAPPhotoDetailsViewController *detailViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:[activity objectForKey:kPAPActivityPhotoKey]];
    //            [self.navigationController pushViewController:detailViewController animated:YES];
    //    if ([activity objectForKey:kCon]) {
    //      PAPAccountViewController *detailViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
    //      [detailViewController setUser:[activity objectForKey:kPAPActivityFromUserKey]];
    //      [self.navigationController pushViewController:detailViewController animated:YES];
    //    }
  } else if (self.paginationEnabled) {
    // load more
    [self loadNextPage];
  }
}

#pragma mark - PFQueryTableViewController

/** Queries all conversations from, or to, a user, and the most up-to-date topic for these. */
- (PFQuery *)queryForTable {
  
  if (![PFUser currentUser]) {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query setLimit:0];
    return query;
  }
  
  PFQuery *toUserQuery = [PFQuery queryWithClassName:self.parseClassName];
  [toUserQuery whereKey:kConversationToUserKey equalTo:[PFUser currentUser]];
  
  PFQuery *fromUserQuery = [PFQuery queryWithClassName:self.parseClassName];
  [fromUserQuery whereKey:kConversationFromUserKey equalTo:[PFUser currentUser]];
  
  PFQuery *query = [PFQuery orQueryWithSubqueries:@[toUserQuery, fromUserQuery]];
  
  [query includeKey:kConversationFromUserKey];
  [query includeKey:kConversationToUserKey];
  [query includeKey:kConversationTopicPostKey];
  
  [query orderByDescending:@"createdAt"];
  
  [query setCachePolicy:kPFCachePolicyNetworkOnly];
  
  // If no objects are loaded in memory, we look to the cache first to fill the table
  // and then subsequently do a query against the network.
  //
  // If there is no network connection, we will hit the cache first.
  if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
    NSLog(@"Loading from cache");
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
  }
  
  
  return query;
}

- (void)objectsDidLoad:(NSError *)error {
  [super objectsDidLoad:error];
  
  if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
    self.tableView.scrollEnabled = NO;
    self.navigationController.tabBarItem.badgeValue = nil;
    
    //        if (!self.blankTimelineView.superview) {
    //            self.blankTimelineView.alpha = 0.0f;
    //            self.tableView.tableHeaderView = self.blankTimelineView;
    //
    //            [UIView animateWithDuration:0.200f animations:^{
    //                self.blankTimelineView.alpha = 1.0f;
    //            }];
    //        }
  } else {
    self.tableView.tableHeaderView = nil;
    self.tableView.scrollEnabled = YES;
    
    NSUInteger unreadCount = self.objects.count;
    
    if (unreadCount > 0) {
      self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadCount];
    } else {
      self.navigationController.tabBarItem.badgeValue = nil;
    }
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
  static NSString *const cellIdentifier = @"LSConversationCell";
  
  LSConversationSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[LSConversationSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    [cell setDelegate:self];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
  }
  
  //  [cell setActivity:object];
  
  //  [cell setIsNew:YES];
  //  if ([lastRefresh compare:[object createdAt]] == NSOrderedAscending) {
  //      [cell setIsNew:YES];
  //  } else {
  //      [cell setIsNew:NO];
  //  }
  //
//  [cell hideSeparator:(indexPath.row == self.objects.count - 1)];
  
  return cell;
}

#pragma mark - LSConversationCellDelegate Methods

- (void)cell:(LSConversationSummaryCell *)cellView didTapActivityButton:(PFObject *)activity {
  // Get image associated with the activity
  //    PFObject *photo = [activity objectForKey:kPAPActivityPhotoKey];
  //
  //    // Push single photo view controller
  //    PAPPhotoDetailsViewController *photoViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:photo];
  //    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)cell:(LSConversationSummaryCell *)cellView didTapUserButton:(PFUser *)user {
  // Push account view controller
  //    PAPAccountViewController *accountViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
  //    [accountViewController setUser:user];
  //    [self.navigationController pushViewController:accountViewController animated:YES];
}


#pragma mark - PAPActivityFeedViewController

+ (NSString *)stringForActivityType:(NSString *)activityType {
  if ([activityType isEqualToString:kConversationTypeMessageKey]) {
    return @"Message";
  } else if ([activityType isEqualToString:kConversationTypeTopicKey]) {
    return @"Topic";
  } else {
    return nil;
  }
}


@end
