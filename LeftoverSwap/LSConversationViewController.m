//
//  DemoViewController.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Parse/Parse.h>

#import "LSConversationViewController.h"
#import "LSConversationHeader.h"
#import "LSConstants.h"
#import "LSConversationUtils.h"
#import "PFObject+Conversation.h"
#import "PFObject+PrivateChannelName.h"

@interface LSConversationViewController ()

@property (nonatomic) NSMutableArray *locallyAddedConversations; /* PFObject */
@property (nonatomic) PFObject *recipient;
@property (nonatomic) NSMutableArray *conversations; /* PFObject */
@property (nonatomic) LSConversationHeader *header;

@end

@implementation LSConversationViewController

#pragma mark - Initialization

- (id)initWithConversations:(NSArray*)conversations recipient:(PFObject*)recipient
{
  self = [super init];
  if (self) {
    self.locallyAddedConversations = [NSMutableArray array];
    self.conversations = [conversations mutableCopy];
    self.recipient = recipient;
    self.title = [self.recipient objectForKey:kUserDisplayNameKey];
  }
  return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.delegate = self;
  self.dataSource = self;
  
  [self setHeaderView];
}

- (void)setConversations:(NSMutableArray *)newConversations
{
  // Add conversations only seen locally
  NSMutableArray *stillNotAdded = [NSMutableArray array];
  for (PFObject *locallyAddedConversation in self.locallyAddedConversations) {
    if (![newConversations containsObject:locallyAddedConversation]) {
      [newConversations addObject:locallyAddedConversation];
      [stillNotAdded addObject:locallyAddedConversation];
    }
  }
  self.locallyAddedConversations = stillNotAdded;
  
  // Ensure proper sorting for conversations (ascending order)
  [newConversations sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    NSDate *date1 = [(PFObject*)obj1 createdAt];
    if (!date1)
      date1 = [NSDate date];
    NSDate *date2 = [(PFObject*)obj2 createdAt];
    if (!date2)
      date2 = [NSDate date];
    return [date1 compare:date2];
  }];
  
  _conversations = newConversations;
}

- (void)updateConversations:(NSArray*)conversations
{
  self.conversations = [conversations mutableCopy];
  [self setHeaderView];
  
  [self.tableView reloadData];
  [self scrollToBottomAnimated:NO];  
}

- (void)setHeaderView
{
  PFObject *latestPost = [self latestPost];
  if (self.header.post == latestPost) return;

  if (self.header)
    [self.header removeFromSuperview];
  
  self.header = [[LSConversationHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
  self.header.post = latestPost;
  [self.view addSubview:self.header];
  
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:self.header.frame];
  [self.tableView setNeedsDisplay];
}

//- (void)buttonPressed:(UIButton*)sender
//{
//  // Testing pushing/popping messages view
//  LSCon *vc = [[DemoViewController alloc] initWithNibName:nil bundle:nil];
//  [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - Instance methods

- (UIButton *)sendButton
{
  // Override to use a custom send button
  // The button's frame is set automatically for you
  return [UIButton defaultSendButton];
}

- (void)addMessage:(NSString*)text forPost:(PFObject*)post
{
  PFObject *newConversation = [self conversationForMessage:text];
  [newConversation setObject:post forKey:kConversationPostKey];

  [newConversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!succeeded)
      return;
    
    [JSMessageSoundEffect playMessageSentSound];
    [self sendPushForConversation:newConversation];
    
    if (self.conversationDelegate)
      [self.conversationDelegate conversationController:self didAddConversation:newConversation];
  }];
  
  [self.locallyAddedConversations addObject:newConversation];
  [self.conversations addObject:newConversation];
  [self setHeaderView];
  [self.tableView reloadData];
  [self scrollToBottomAnimated:NO];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.conversations.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
  PFObject *newConversation = [self conversationForMessage:text];
  
  [newConversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!succeeded)
      return;
    
    [JSMessageSoundEffect playMessageSentSound];
    [self sendPushForConversation:newConversation];
    
    if (self.conversationDelegate)
      [self.conversationDelegate conversationController:self didAddConversation:newConversation];
  }];

  [self.locallyAddedConversations addObject:newConversation];
  [self.conversations addObject:newConversation];
  [self setHeaderView];
  [self finishSend];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
  PFObject *fromUser = [self.conversations[indexPath.row] objectForKey:kConversationFromUserKey];
  return [[fromUser objectId] isEqualToString:[[PFUser currentUser] objectId]] ? JSBubbleMessageTypeOutgoing : JSBubbleMessageTypeIncoming;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return JSBubbleMessageStyleSquare;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
  return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
  return JSMessagesViewAvatarPolicyNone;
}

- (JSAvatarStyle)avatarStyle
{
  return JSAvatarStyleSquare;
}

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.conversations[indexPath.row] objectForKey:kConversationMessageKey];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDate *conversationDate = [self.conversations[indexPath.row] createdAt];
  if (!conversationDate)
    conversationDate = [NSDate date];
  return conversationDate;
}

- (UIImage *)avatarImageForIncomingMessage
{
  return [UIImage imageNamed:@"demo-avatar-woz"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
  return [UIImage imageNamed:@"demo-avatar-jobs"];
}

#pragma mark - Private methods

- (PFObject*)conversationForMessage:(NSString*)text
{
  PFObject *newConversation = [PFObject objectWithClassName:kConversationClassKey];
  [newConversation setObject:text forKey:kConversationMessageKey];
  [newConversation setObject:[PFUser currentUser] forKey:kConversationFromUserKey];
  [newConversation setObject:self.recipient forKey:kConversationToUserKey];
  [newConversation setObject:[self latestPost] forKey:kConversationPostKey];
  return newConversation;
}

- (void)sendPushForConversation:(PFObject*)conversation
{
  PFPush *push = [[PFPush alloc] init];
  PFObject *recipient = [conversation objectForKey:kConversationToUserKey];
  [push setChannel:[recipient privateChannelName]];

//  PFObject *post = [conversation objectForKey:kConversationPostKey];
  NSString *message = [NSString stringWithFormat:@"%@: %@",
                       [[PFUser currentUser] objectForKey:kUserDisplayNameKey],
                       [conversation objectForKey:kConversationMessageKey]];
  
  NSDictionary *data = @{
                         @"alert": message,
                         @"c": [conversation objectId],
                         @"badge": @"Increment" // +1 to application badge number
                        };
  [push setData:data];
  [push sendPushInBackground];
}

- (PFObject*)latestPost
{
  return [[self.conversations lastObject] objectForKey:kConversationPostKey];
}

@end
