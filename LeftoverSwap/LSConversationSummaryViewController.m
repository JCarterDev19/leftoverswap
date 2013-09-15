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

@property (nonatomic) NSMutableDictionary *recipientConversations; /* NSString *objectId => NSArray of PFObjects */
@property (nonatomic) NSArray *summarizedObjects; /* NSArray of PFObjects */

@end

@implementation LSConversationSummaryViewController

#pragma mark - UIViewController

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLSConversationCreatedNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Conversations" image:[UIImage imageNamed:@"TabBarMessage"] tag:1];
    self.title = @"Conversations";
    self.recipientConversations = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversationCreated:) name:kLSConversationCreatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
  }
  return self;
}

- (void)viewDidLoad
{
  [self loadConversations];
}

- (void)viewWillAppear:(BOOL)animated
{
  // Reset badge values (we're looking at this view now)
  self.navigationController.tabBarItem.badgeValue = nil;

  // Need to refresh timestamps
  [self.tableView reloadData];
}

- (void)didBecomeActive:(NSNotification*)notification
{
  if (![PFUser currentUser]) return;
  [self viewWillAppear:NO];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [LSConversationSummaryCell heightForCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  PFObject *conversation = self.summarizedObjects[indexPath.row][0];
  PFObject *recipient = [conversation recipient];
  
  LSConversationViewController *conversationViewController = [[LSConversationViewController alloc] initWithConversations:[self conversationsForRecipient:recipient] recipient:recipient post:[conversation objectForKey:kConversationPostKey]];
  conversationViewController.conversationDelegate = self;
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

- (void)loadConversations
{
  PFQuery *query = [self queryForTable];
  query.cachePolicy = kPFCachePolicyCacheThenNetwork;
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    [self partitionConversationsByRecipient:objects];
    [self.tableView reloadData];
  }];
}

#pragma mark - Instance methods

- (void)addNewConversation:(NSString*)text forPost:(PFObject*)post
{
  PFObject *recipient = [post objectForKey:kPostUserKey];
  
  LSConversationViewController *conversationViewController = [[LSConversationViewController alloc] initWithConversations:[self conversationsForRecipient:recipient] recipient:recipient post:post];
  conversationViewController.conversationDelegate = self;
  conversationViewController.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:conversationViewController animated:NO];
  [conversationViewController addMessage:text];
}

#pragma mark - LSConversationControllerDelegate

- (void)conversationController:(LSConversationViewController *)conversationController didAddConversation:(PFObject *)conversation
{
  [[self conversationsForRecipient:[conversation recipient]] insertObject:conversation atIndex:0];
  [self updateSummarizedObjects];
  [self.tableView reloadData];
}

- (void)conversationCreated:(NSNotification*)notification
{
  [self incrementBadgeValue];
  [self loadConversations];
}

- (void)incrementBadgeValue
{
  UITabBarItem *tabBarItem = self.navigationController.tabBarItem;
  NSString *currentBadgeValue = tabBarItem.badgeValue;
  
  if (currentBadgeValue && currentBadgeValue.length > 0) {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *badgeValue = [numberFormatter numberFromString:currentBadgeValue];
    tabBarItem.badgeValue = [numberFormatter stringFromNumber:@([badgeValue intValue] + 1)];
  } else {
    tabBarItem.badgeValue = @"1";
  }
}

#pragma mark - Private methods

- (NSMutableArray*)conversationsForRecipient:(PFObject*)recipient
{
  NSString *recipientId = [recipient objectId];
  NSMutableArray *conversations = self.recipientConversations[recipientId];
  if (!conversations)
    self.recipientConversations[recipientId] = conversations = [NSMutableArray array];
  return conversations;
}

- (void)partitionConversationsByRecipient:(NSArray*)conversations
{
  NSMutableDictionary *recipientConversations = [NSMutableDictionary dictionary];
  for (PFObject* conversation in conversations) {
    NSString *recipientId = [[conversation recipient] objectId];
    NSMutableArray *conversationsForRecipient = recipientConversations[recipientId];
    if (!conversationsForRecipient)
      recipientConversations[recipientId] = conversationsForRecipient = [NSMutableArray array];
    [conversationsForRecipient addObject:conversation];
  }
  self.recipientConversations = recipientConversations;
  [self updateSummarizedObjects];
}

- (void)updateSummarizedObjects
{
  // Ensure all results are sorted by recency
  self.summarizedObjects = [[self.recipientConversations allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [[(PFObject*)((NSArray*)obj2[0]) createdAt] compare:[(PFObject*)((NSArray*)obj1[0]) createdAt]];
  }];
}

@end
