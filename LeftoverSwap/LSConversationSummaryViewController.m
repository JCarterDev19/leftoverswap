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

@implementation LSConversationSummaryViewController

#pragma mark - UIViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Conversations" image:[UIImage imageNamed:@"TabBarMessage"] tag:1];
    
    self.title = @"Conversations";

    self.parseClassName = kConversationClassKey;
    self.pullToRefreshEnabled = NO;
    self.paginationEnabled = NO;
  }
  return self;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}

#pragma mark - PFQueryTableViewController

/** Queries all conversations from, or to, a user, and the most up-to-date topic for these. */
- (PFQuery *)queryForTable
{  
  NSAssert([PFUser currentUser], @"User can't be nil");

  PFQuery *toUserQuery = [PFQuery queryWithClassName:self.parseClassName];
  [toUserQuery whereKey:kConversationToUserKey equalTo:[PFUser currentUser]];
  
  PFQuery *fromUserQuery = [PFQuery queryWithClassName:self.parseClassName];
  [fromUserQuery whereKey:kConversationFromUserKey equalTo:[PFUser currentUser]];
  
  PFQuery *query = [PFQuery orQueryWithSubqueries:@[toUserQuery, fromUserQuery]];
  
  [query includeKey:kConversationFromUserKey];
  [query includeKey:kConversationToUserKey];
  [query includeKey:kConversationPostKey];
  
  [query orderByDescending:@"createdAt"];
  
  [query setCachePolicy:kPFCachePolicyCacheElseNetwork];
  
  return query;
}

- (void)objectsDidLoad:(NSError *)error
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
  static NSString *const cellIdentifier = @"LSConversationSummaryCell";
  
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

- (void)cell:(LSConversationSummaryCell *)cellView didTapActivityButton:(PFObject *)activity
{
  // Get image associated with the activity
  //    PFObject *photo = [activity objectForKey:kPAPActivityPhotoKey];
  //
  //    // Push single photo view controller
  //    PAPPhotoDetailsViewController *photoViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:photo];
  //    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)cell:(LSConversationSummaryCell *)cellView didTapUserButton:(PFUser *)user
{
  // Push account view controller
  //    PAPAccountViewController *accountViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
  //    [accountViewController setUser:user];
  //    [self.navigationController pushViewController:accountViewController animated:YES];
}

@end
