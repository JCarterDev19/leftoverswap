//
//  LSNewConversationViewController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/8/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "JSMessagesViewController.h"

@class PFObject;

@interface LSNewConversationViewController : JSMessagesViewController

-initWithPost:(PFObject*)post;

@end
