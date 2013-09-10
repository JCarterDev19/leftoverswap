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

@interface LSConversationViewController ()

@property (nonatomic) LSConversationHeader *header;

@end

@implementation LSConversationViewController

#pragma mark - Initialization

- (UIButton *)sendButton
{
  // Override to use a custom send button
  // The button's frame is set automatically for you
  return [UIButton defaultSendButton];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.delegate = self;
  self.dataSource = self;
//
//  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
//                                                                                         target:self
//                                                                                         action:@selector(buttonPressed:)];
//  self.navigationItem.title = @"New Conversation";
//  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
//  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Message" style:UIBarButtonItemStyleDone target:self action:@selector(postPressed:)];
}

- (void)viewDidAppear:(BOOL)animated
{
  [self scrollToBottomAnimated:YES];
}

- (void)setConversations:(NSMutableArray *)conversations
{
  _conversations = conversations;
  [self.tableView reloadData];
}

- (void)setPost:(PFObject *)post
{
  _post = post;

  if (self.header)
    [self.header removeFromSuperview];

  self.header = [[LSConversationHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
  self.header.post = self.post;
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

- (void)addMessage:(NSString*)text
{
  PFObject *newConversation = [self conversationForMessage:text];
  [self.conversations addObject:newConversation];
  
  [newConversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    [JSMessageSoundEffect playMessageSentSound];
    NSLog(@"Sent message for post %@ and text %@", [self.post objectId], text);
  }];
  [self.tableView reloadData];
  [self scrollToBottomAnimated:NO];
  
  if (self.conversationDelegate)
    [self.conversationDelegate conversationController:self didAddConversation:newConversation];
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
  [self.conversations addObject:newConversation];
  
  // TODO: maybe only add this when it's been saved instead?
  [newConversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    [JSMessageSoundEffect playMessageSentSound];
  }];

  [self finishSend];

  if (self.conversationDelegate)
    [self.conversationDelegate conversationController:self didAddConversation:newConversation];

//  if((self.conversations.count - 1) % 2)
//    
//  else
//    [JSMessageSoundEffect playMessageReceivedSound];
  
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([[self.conversations[indexPath.row] objectForKey:kConversationFromUserKey] isEqual:[PFUser currentUser]]) {
    return JSBubbleMessageTypeOutgoing;
  } else {
    return JSBubbleMessageTypeIncoming;
  }
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

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.conversations[indexPath.row] objectForKey:kConversationMessageKey];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.conversations[indexPath.row] createdAt];
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
  NSAssert(self.post, @"post must not be nil");
  PFObject *newConversation = [PFObject objectWithClassName:kConversationClassKey];
  [newConversation setObject:text forKey:kConversationMessageKey];
  [newConversation setObject:[PFUser currentUser] forKey:kConversationFromUserKey];
  [newConversation setObject:self.recipient forKey:kConversationToUserKey];
  [newConversation setObject:self.post forKey:kConversationPostKey];
  return newConversation;
}

@end
