//
//  LSConversationUtils.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/14/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSConversationUtils.h"
#import <Parse/Parse.h>
#import "LSConstants.h"
#import "PFObject+PrivateChannelName.h"

@implementation LSConversationUtils

+ (void)sendTakenPushNotificationForPost:(PFObject*)post
{
  // Find the recipient of conversations r/e the post that the seller has interacted with.
  PFQuery *query = [PFQuery queryWithClassName:kConversationClassKey];
  [query whereKey:kConversationPostKey equalTo:post];
  [query whereKey:kConversationFromUserKey equalTo:[PFUser currentUser]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    PFPush *push = [[PFPush alloc] init];
    NSMutableArray *channels = [NSMutableArray arrayWithCapacity:objects.count];
    for (PFObject *conversation in objects) {
      PFObject *user = [conversation objectForKey:kConversationToUserKey];
      [channels addObject:[user privateChannelName]];
    }
    [push setChannels:channels];
    [push setData:@{
     @"alert": [NSString stringWithFormat:@"%@ was taken", [post objectForKey:kPostTitleKey]],
     @"pt": [post objectId]
     }];
    [push sendPushInBackground];
  }];
}

+ (BOOL)conversations:(NSMutableArray*)conversations containsConversation:(PFObject*)newConversation
{
  BOOL doesExist = NO;
  for(PFObject *conversation in conversations) {
    if ([[conversation objectId] isEqualToString:[newConversation objectId]]) {
      doesExist = YES;
      break;
    }
  }
  return doesExist;
}

@end
