//
//  PFObject+Conversation.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/10/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFObject (Conversation)

- (PFObject*)recipient;

// Conversations are defined as equal if they have the same object id
- (BOOL)isEqual:(id)object;

@end
