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
  if ([[toUser objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
    return fromUser;
  } else {
    return toUser;
  }
}

- (BOOL)isEqual:(id)object
{
  if (![object isKindOfClass:[PFObject class]]) return NO;
  PFObject *other = object;
  return [self.objectId isEqualToString:other.objectId];
}

- (NSUInteger)hash
{
  return self.objectId.hash;
}

@end
