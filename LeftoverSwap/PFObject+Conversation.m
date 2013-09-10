//
//  PFObject+Conversation.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/10/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "PFObject+Conversation.h"
#import "LSConstants.h"

@implementation PFObject (Conversation)

- (PFObject*)recipient
{
  PFObject *toUser = [self objectForKey:kConversationToUserKey];
  PFObject *fromUser = [self objectForKey:kConversationFromUserKey];
  if (toUser != [PFUser currentUser]) {
    return toUser;
  } else {
    return fromUser;
  }
}

@end
