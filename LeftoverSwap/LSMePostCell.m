//
//  LSMePostCell.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/13/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSMePostCell.h"
#import "LSConversationHeader.h"

@interface LSMePostCell ()

@property (nonatomic) LSConversationHeader *header;

@end

@implementation LSMePostCell

+ (NSInteger)heightForCell
{
  return 50;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.header = [[LSConversationHeader alloc] initWithFrame:self.bounds];
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      [self addSubview:self.header];
    }
    return self;
}

- (void)setPost:(PFObject *)post
{
  self.header.post = post;
  [self.header setNeedsDisplay];
//  ((LSConversationHeader*)[self subviews][0]).post = post;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
