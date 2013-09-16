//
//  LSMeViewController.m
//  LeftoverSwap
//
//  Created by Dan Newman on 9/4/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSMeViewController.h"

#import <Parse/Parse.h>

#import "LSLoginSignupViewController.h"
#import "LSTabBarController.h"
#import "LSAppDelegate.h"
#import "LSMePostCell.h"
#import "LSConstants.h"

@interface LSMeViewController ()

@property (nonatomic) PFUser *user;
@property (nonatomic) NSMutableArray *objects;

@end

@implementation LSMeViewController;

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLSPostCreatedNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLSPostTakenNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLSUserLogInNotification object:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:[UIImage imageNamed:@"TabBarMe"] tag:2];
    self.objects = [NSMutableArray array];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCreated:) name:kLSPostCreatedNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postTaken:) name:kLSPostTakenNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogIn:) name:kLSUserLogInNotification object:nil];
  
  self.navigationItem.title = [[PFUser currentUser] objectForKey:kUserDisplayNameKey];
  
  self.navigationItem.leftBarButtonItem = nil;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Terms" style:UIBarButtonItemStyleBordered target:self action:@selector(termsOfService:)];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStyleDone target:self action:@selector(logout:)];

  
  [self loadPosts];
}

- (void)loadPosts
{
  PFQuery *query = [PFQuery queryWithClassName:kPostClassKey];
  [query whereKey:kPostUserKey equalTo:[PFUser currentUser]];
  [query orderByDescending:@"createdAt"];
  query.cachePolicy = kPFCachePolicyNetworkElseCache;

  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    self.objects = [NSMutableArray arrayWithArray:objects];
    [self.tableView reloadData];
  }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  PFObject *post = self.objects[indexPath.row];
//
//  LSConversationViewController *conversationViewController = [[LSConversationViewController alloc] initWithConversations:[self conversationsForRecipient:recipient] recipient:recipient post:[conversation objectForKey:kConversationPostKey]];
//  conversationViewController.conversationDelegate = self;
//  conversationViewController.hidesBottomBarWhenPushed = YES;
//  [self.navigationController pushViewController:conversationViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [LSMePostCell heightForCell];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *const cellIdentifier = @"LSMePostCell";
  
  LSMePostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[LSMePostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  [cell setPost:self.objects[indexPath.row]];
  return cell;
}

#pragma mark - Callbacks

- (void)userDidLogIn:(NSNotification*)note
{
  // Don't want to keep around old objects
  self.navigationItem.title = [[PFUser currentUser] objectForKey:kUserDisplayNameKey];
  self.objects = nil;
  [self.tableView reloadData];
  [self loadPosts];
}

- (void)postCreated:(NSNotification *)note
{
  PFObject *post = note.userInfo[kLSPostKey];
  [self.objects insertObject:post atIndex:0];
  [self.tableView reloadData];
}

- (void)postTaken:(NSNotification *)notification
{
  // Just set post taken notification instead.
  // The ConversationHeader view should have updated its own post and redrawn it.
  PFObject *takenPost = notification.userInfo[kLSPostKey];
  for (PFObject *post in self.objects) {
    if ([[post objectId] isEqualToString:[takenPost objectId]]) {
      [post setObject:@(YES) forKey:kPostTakenKey];
    }
  }
}

- (void)logout:(id)sender
{
  [PFUser logOut];
  [(LSTabBarController*)self.tabBarController presentSignInView:YES];
}

- (void)termsOfService:(id)sender
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.leftoverswap.com/tos.html"]];
}

@end
