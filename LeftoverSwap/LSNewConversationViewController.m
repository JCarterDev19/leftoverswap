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

@end

@implementation LSNewConversationViewController

- (id)initWithPost:(PFObject*)post
{
  self = [super init];
  if (self) {
    LSConversationHeader *header = [[LSConversationHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    header.post = post;
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
  self.navigationItem.title = @"New Conversation";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
}

- (void)cancelPressed:(id)sender
{
  [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
  [self finishSend];
}

@end
