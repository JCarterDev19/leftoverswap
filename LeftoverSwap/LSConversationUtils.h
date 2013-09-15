//
//  LSConversationUtils.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/14/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;

@interface LSConversationUtils : NSObject

+ (void)sendTakenPushNotificationForPost:(PFObject*)post;

+ (BOOL)conversations:(NSMutableArray*)conversations containsConversation:(PFObject*)newConversation;

@end
