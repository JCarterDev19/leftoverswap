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
@property (nonatomic) UILabel *recipientLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) PFImageView *thumbnailImageView;

@end

@implementation LSConversationSummaryCell

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

      self.recipientLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 12, 150, 18)];
      [self.recipientLabel setFont:[UIFont boldSystemFontOfSize:15]];
      [self.recipientLabel setTextColor:[UIColor blackColor]];
      [self.recipientLabel setNumberOfLines:0];
      [self.recipientLabel setBackgroundColor:[UIColor clearColor]];
      [self.mainView addSubview:self.recipientLabel];

      self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 33, 230, 14)];
      [self.messageLabel setFont:[UIFont systemFontOfSize:12]];
      [self.messageLabel setTextColor:[UIColor blackColor]];
      [self.messageLabel setNumberOfLines:0];
      [self.messageLabel setBackgroundColor:[UIColor clearColor]];
      [self.mainView addSubview:self.messageLabel];
      
      self.thumbnailImageView = [[PFImageView alloc] initWithFrame:CGRectMake(12, 12, 35, 35)];
      self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
      [self.mainView addSubview:self.thumbnailImageView];
      
      self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 110, 14)];
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
  self.messageLabel.text = [conversation objectForKey:kConversationMessageKey];
  self.timeLabel.text = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[conversation createdAt]];
  self.recipientLabel.text = [[conversation recipient] objectForKey:kUserDisplayNameKey];
  
  // Clear out last thumbnail unconditionally
  self.thumbnailImageView.file = nil;

  PFObject *post = [conversation objectForKey:kConversationPostKey];
  if (post) {
    PFFile *thumbnail = [post objectForKey:kPostThumbnailKey];
    self.thumbnailImageView.file = thumbnail;
    [self.thumbnailImageView loadInBackground];
  }

  [self setNeedsDisplay];
}

@end
