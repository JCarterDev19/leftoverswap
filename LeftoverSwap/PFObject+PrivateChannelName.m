//
//  PFUser+PrivateChannelName.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/4/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "PFObject+PrivateChannelName.h"

@implementation PFObject (PrivateChannelName)

- (NSString *)privateChannelName
{
  NSAssert([self objectId], @"objectId is not nil");
  return [NSString stringWithFormat:@"user_%@", [self objectId]];
}

@end
