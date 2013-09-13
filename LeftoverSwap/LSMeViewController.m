//
//  LSMeViewController.m
//  LeftoverSwap
//
//  Created by Dan Newman on 9/4/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSMeViewController.h"
#import "LSLoginSignupViewController.h"
#import "LSTabBarController.h"
#import "LSAppDelegate.h"
#import "LSMePostCell.h"
#import "LSConstants.h"

@interface LSMeViewController ()

@property (nonatomic) IBOutlet UILabel *userLabel;
@property (nonatomic) PFUser *user;

@end

@implementation LSMeViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:[UIImage imageNamed:@"TabBarMe"] tag:2];
    self.parseClassName = kPostClassKey;
    self.pullToRefreshEnabled = NO;
    self.paginationEnabled = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.navigationItem.title = [[PFUser currentUser] objectForKey:kUserDisplayNameKey];
  
  self.navigationItem.leftBarButtonItem = nil;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Terms" style:UIBarButtonItemStyleBordered target:self action:@selector(termsOfService:)];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStyleDone target:self action:@selector(logout:)];
  self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.900 green:0.247 blue:0.294 alpha:1.000];
}

#pragma mark - Table dataSource methods

//- (void)objectsDidLoad:(NSError *)error
//{
//  [super objectsDidLoad:error];
//  [self.tableView reloadData];
//}

- (PFQuery *)queryForTable
{
  PFQuery *query = [PFQuery queryWithClassName:kPostClassKey];
  [query whereKey:kPostUserKey equalTo:[PFUser currentUser]];
  [query orderByDescending:@"createdAt"];
  query.cachePolicy = kPFCachePolicyCacheThenNetwork;
  return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *const cellIdentifier = @"LSMePostCell";
  
  LSMePostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[LSMePostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  cell.post = self.objects[indexPath.row];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [LSMePostCell heightForCell];
}

#pragma mark - Callbacks

- (void)logout:(id)sender
{
  [PFUser logOut];
  [(LSTabBarController*)self.tabBarController presentSignInView];
}

- (void)termsOfService:(id)sender
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.leftoverswap.com/tos.html"]];
}

@end
