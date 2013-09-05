//
//  PFUser+PrivateChannelName.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/4/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "PFUser+PrivateChannelName.h"

@implementation PFUser (PrivateChannelName)

- (NSString *)privateChannelName
{
  NSAssert([self objectId], @"objectId is not nil");
  return [NSString stringWithFormat:@"user_%@", [self objectId]];
}

@end
