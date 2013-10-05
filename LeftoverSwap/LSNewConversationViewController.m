//
//  LSNewConversationViewController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/8/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSNewConversationViewController.h"
#import "LSConversationHeader.h"

@interface LSNewConversationViewController ()

@property (nonatomic) PFObject *post;

@end

@implementation LSNewConversationViewController

- (id)initWithPost:(PFObject*)post
{
  self = [super init];
  if (self) {
    LSConversationHeader *header = [[LSConversationHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    header.post = self.post = post;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:header.frame];
    [self.view addSubview:header];
  }
  return self;
}

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

  self.navigationItem.title = @"New Conversation";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
}

- (void)cancelPressed:(id)sender
{
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

#pragma mark - Messages view delegate

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
  if (self.conversationDelegate)
    [self.conversationDelegate conversationController:self didSendText:text forPost:self.post];
  [self finishSend];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
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

@end
