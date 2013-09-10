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
#import "LSConversationViewController.h"
#import "PFObject+Conversation.h"

@interface LSConversationSummaryViewController ()

@property (nonatomic) NSArray *summarizedObjects; /* NSArray of PFObjects */
@property (nonatomic) BOOL needsReload;

@end

@implementation LSConversationSummaryViewController

#pragma mark - UIViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Conversations" image:[UIImage imageNamed:@"TabBarMessage"] tag:1];
    
    self.title = @"Conversations";
    self.needsReload = YES;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  if (self.needsReload) {
    self.needsReload = NO;
    [[self queryForTable] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      self.summarizedObjects = [self partitionConversationsByRecipient:objects];
      [self.tableView reloadData];
    }];
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  PFObject *conversation = self.summarizedObjects[indexPath.row][0];
  PFObject *recipient = [conversation recipient];
  PFQuery *query = [self queryForRecipient:recipient];
  //  query.cachePolicy = kPFCachePolicyCacheElseNetwork;
  
  LSConversationViewController *conversationViewController = [[LSConversationViewController alloc] init];
  conversationViewController.conversationDelegate = self;
  conversationViewController.recipient = recipient;
  conversationViewController.post = [conversation objectForKey:kConversationPostKey];
  
  // This should never block, as we get into this state only by viewing previous screens
  [query findObjectsInBackgroundWithBlock:^(NSArray *previousConversations, NSError *error) {
    if (!error) {
      conversationViewController.conversations = [NSMutableArray arrayWithArray:previousConversations];
    }
  }];
  
  conversationViewController.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:conversationViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.summarizedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *const cellIdentifier = @"LSConversationSummaryCell";
  
  LSConversationSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[LSConversationSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  cell.conversation = self.summarizedObjects[indexPath.row][0];
  return cell;
}

/** Queries all conversations from, or to, a user, and the most up-to-date topic for these. */
- (PFQuery *)queryForTable
{  
  NSAssert([PFUser currentUser], @"User can't be nil");

  PFQuery *toUserQuery = [PFQuery queryWithClassName:kConversationClassKey];
  [toUserQuery whereKey:kConversationToUserKey equalTo:[PFUser currentUser]];
  
  PFQuery *fromUserQuery = [PFQuery queryWithClassName:kConversationClassKey];
  [fromUserQuery whereKey:kConversationFromUserKey equalTo:[PFUser currentUser]];
  
  PFQuery *query = [PFQuery orQueryWithSubqueries:@[toUserQuery, fromUserQuery]];
  
  [query includeKey:kConversationFromUserKey];
  [query includeKey:kConversationToUserKey];
  [query includeKey:kConversationPostKey];
  
  [query orderByDescending:@"createdAt"];
  
  return query;
}

#pragma mark - Instance methods

- (void)addNewConversation:(NSString*)text forPost:(PFObject*)post
{
  PFObject *toUser = [post objectForKey:kPostUserKey];
  PFQuery *query = [self queryForRecipient:toUser];
  
  query.cachePolicy = kPFCachePolicyCacheElseNetwork;

  LSConversationViewController *conversationViewController = [[LSConversationViewController alloc] init];
  conversationViewController.conversationDelegate = self;
  conversationViewController.recipient = toUser;
  conversationViewController.post = post;

  // This should never block, as we get into this state only by viewing previous screens
  [query findObjectsInBackgroundWithBlock:^(NSArray *previousConversations, NSError *error) {
    if (!error) {
      conversationViewController.conversations = [NSMutableArray arrayWithArray:previousConversations];
      [conversationViewController addMessage:text];
    }
  }];

  conversationViewController.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:conversationViewController animated:NO];
}

#pragma mark - LSConversationControllerDelegate

- (void)conversationController:(LSConversationViewController *)conversationController didAddConversation:(PFObject *)conversation
{
  self.needsReload = YES;
}

#pragma mark - Private methods

- (PFQuery*)queryForRecipient:(PFObject*)recipient
{
  PFQuery *toUserQuery = [PFQuery queryWithClassName:kConversationClassKey];
  [toUserQuery whereKey:kConversationToUserKey equalTo:[PFUser currentUser]];
  [toUserQuery whereKey:kConversationFromUserKey equalTo:recipient];
  
  PFQuery *fromUserQuery = [PFQuery queryWithClassName:kConversationClassKey];
  [fromUserQuery whereKey:kConversationFromUserKey equalTo:[PFUser currentUser]];
  [fromUserQuery whereKey:kConversationToUserKey equalTo:recipient];
  
  PFQuery *query = [PFQuery orQueryWithSubqueries:@[toUserQuery, fromUserQuery]];
  
  [query includeKey:kConversationFromUserKey];
  [query includeKey:kConversationToUserKey];
  [query includeKey:kConversationPostKey];
  
  [query orderByAscending:@"createdAt"];
  return query;
}

- (NSArray*)partitionConversationsByRecipient:(NSArray*)conversations
{
  NSMutableDictionary *recipientConversations = [NSMutableDictionary dictionary];
  for (PFObject* conversation in conversations) {
    NSString *recipientId = [[conversation recipient] objectId];
    NSMutableArray *conversationsForRecipient = recipientConversations[recipientId];
    if (!conversationsForRecipient)
      recipientConversations[recipientId] = conversationsForRecipient = [NSMutableArray array];
    [conversationsForRecipient addObject:conversation];
  }
  // Ensure all results are sorted by recency
  return [[recipientConversations allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [[(PFObject*)((NSArray*)obj2[0]) createdAt] compare:[(PFObject*)((NSArray*)obj1[0]) createdAt]];
  }];
}

@end
