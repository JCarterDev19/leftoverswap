//
//  LSMePostCell.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/13/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <Parse/Parse.h>

// Very similar to LSConversationHeader

@interface LSMePostCell : UITableViewCell

+ (NSInteger)heightForCell;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setPost:(PFObject*)post;

@end
