//
//  PFObject+Utilities.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/11/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "PFObject+Utilities.h"

@implementation PFObject (User)

- (BOOL)isCurrentUser
{
  return [[[PFUser currentUser] objectId] isEqualToString:[self objectId]];
}

@end
