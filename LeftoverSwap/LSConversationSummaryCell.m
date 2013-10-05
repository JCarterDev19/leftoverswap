//
//  LSConversationSummaryCell.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/11/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSConversationSummaryCell.h"

#import <Parse/Parse.h>

#import "TTTTimeIntervalFormatter.h"
#import "LSConstants.h"
#import "PFObject+Conversation.h"

static TTTTimeIntervalFormatter *timeFormatter;

@interface LSConversationSummaryCell ()

@property (nonatomic) UIView *mainView;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) PFImageView *thumbnailImageView;

@end

@implementation LSConversationSummaryCell

+ (NSInteger)heightForCell
{
  return 50;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      if (!timeFormatter) {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
      }
      
      self.clipsToBounds = YES;
      self.opaque = YES;
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      self.accessoryType = UITableViewCellAccessoryNone;
      self.backgroundColor = [UIColor clearColor];

      self.mainView = [[UIView alloc] initWithFrame:self.contentView.frame];

      self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 6, 174, 18)];
      [self.titleLabel setTextColor:[UIColor blackColor]];
      [self.titleLabel setBackgroundColor:[UIColor clearColor]];
      [self.mainView addSubview:self.titleLabel];

      self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 26, 263, 14)];
      [self.messageLabel setFont:[UIFont systemFontOfSize:12]];
      [self.messageLabel setTextColor:[UIColor blackColor]];
      [self.messageLabel setBackgroundColor:[UIColor clearColor]];
      [self.mainView addSubview:self.messageLabel];
      
      self.thumbnailImageView = [[PFImageView alloc] initWithFrame:CGRectMake(8, 7, 35, 35)];
      self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
      [self.mainView addSubview:self.thumbnailImageView];
      
      self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(228, 6, 83, 14)];
      [self.timeLabel setFont:[UIFont systemFontOfSize:12]];
      [self.timeLabel setTextAlignment:NSTextAlignmentRight];
      [self.timeLabel setTextColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000]];
      [self.timeLabel setBackgroundColor:[UIColor clearColor]];
      [self.mainView addSubview:self.timeLabel];
      
      [self.contentView addSubview:self.mainView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setConversation:(PFObject *)conversation
{
  PFObject *post = [conversation objectForKey:kConversationPostKey];

  self.messageLabel.text = [conversation objectForKey:kConversationMessageKey];
  self.timeLabel.text = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[conversation createdAt]];
  
  NSString *recipientText = [[conversation recipient] objectForKey:kUserDisplayNameKey];
  NSString *postText = [NSString stringWithFormat:@"  for %@", [post objectForKey:kPostTitleKey]];
  
  NSMutableAttributedString *titleLabelText = [[NSMutableAttributedString alloc] initWithString:[recipientText stringByAppendingString:postText]];
  [titleLabelText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, [recipientText length])];
  [titleLabelText addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:13] range:NSMakeRange([recipientText length], [postText length])];
  
  self.titleLabel.attributedText = titleLabelText;
  
  // Clear out last thumbnail unconditionally
  self.thumbnailImageView.file = nil;

  PFFile *thumbnail = [post objectForKey:kPostThumbnailKey];
  self.thumbnailImageView.file = thumbnail;
  [self.thumbnailImageView loadInBackground];

  [self setNeedsDisplay];
}

@end
