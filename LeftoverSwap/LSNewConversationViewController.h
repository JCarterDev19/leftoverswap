//
//  LSNewConversationViewController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/8/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "JSMessagesViewController.h"

@class PFObject, LSNewConversationViewController;

@protocol LSNewConversationDelegate <NSObject>

- (void)conversationController:(LSNewConversationViewController*)conversation didSendText:(NSString*)text forPost:(PFObject*)post;

@end

@interface LSNewConversationViewController : JSMessagesViewController <JSMessagesViewDelegate>

@property (nonatomic, weak) id<LSNewConversationDelegate> conversationDelegate;

-initWithPost:(PFObject*)post;

@end
