//
//  PAPActivityFeedViewController.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/9/12.
//

#import <Parse/Parse.h>
#import "LSConversationCell.h"

@interface LSConversationViewController : PFQueryTableViewController <LSConversationCellDelegate>

+ (NSString *)stringForActivityType:(NSString *)activityType;

@end
