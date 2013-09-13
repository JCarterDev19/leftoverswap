//
//  LSConversationSummaryViewController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/9/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "LSConversationViewController.h"

@interface LSConversationSummaryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, LSConversationControllerDelegate>

//- (void)presentConversationForPost:(PFObject*)post;
- (void)addNewConversation:(NSString*)text forPost:(PFObject*)post;

@end
