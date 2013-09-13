//
//  LSConversationHeader.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/8/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSConversationHeader.h"
#import <Parse/Parse.h>
#import "LSConstants.h"
#import "UIImage+RoundedCornerAdditions.h"
#import "PFObject+Utilities.h"

typedef NS_ENUM(NSUInteger, LSConversationHeaderState) {
  LSConversationHeaderStateDefault,
  LSConversationHeaderStateSeller,
  LSConversationHeaderStateTaken
};

@interface LSConversationHeader ()

@property (nonatomic) PFImageView *imageView;
@property (nonatomic) LSConversationHeaderState state;

@end

@implementation LSConversationHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor whiteColor];
      self.state = LSConversationHeaderStateDefault;
      self.imageView = [[PFImageView alloc] initWithFrame:CGRectMake(8, 7, 35, 35)];
      self.imageView.contentMode = UIViewContentModeScaleAspectFit;

//      NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[self.post createdAt]];
//      CGSize timeLabelSize = [timeString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(nameLabelMaxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeTailTruncation];
//      UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, nameLabelY+userButtonSize.height, timeLabelSize.width, timeLabelSize.height)];
//      [timeLabel setText:timeString];
//      [timeLabel setFont:[UIFont systemFontOfSize:11.0f]];
//      [timeLabel setTextColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:1.0f]];
//      [timeLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
//      [timeLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
//      [timeLabel setBackgroundColor:[UIColor clearColor]];
//      [self addSubview:timeLabel];
//
    }
    return self;
}

- (void)setPost:(PFObject *)post
{
  _post = post;

  if ([[self.post objectForKey:kPostTakenKey] boolValue])
    self.state = LSConversationHeaderStateTaken;
  else if ([[self.post objectForKey:kPostUserKey] isCurrentUser])
    self.state = LSConversationHeaderStateSeller;
  
  [self setViewsForState:self.state];

  [self setNeedsDisplay];
}

- (void)markAsTaken:(id)sender
{
  [self.post setObject:@(YES) forKey:kPostTakenKey];

  self.state = LSConversationHeaderStateTaken;
  [self setViewsForState:self.state];

  [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      NSLog(@"Taken set for post %@", [self.post objectForKey:kPostTitleKey]);
    } else {
      [self.post setObject:@(NO) forKey:kPostTakenKey];
      if ([[self.post objectForKey:kPostUserKey] isCurrentUser])
        self.state = LSConversationHeaderStateSeller;
      else
        self.state = LSConversationHeaderStateDefault;

      [self setViewsForState:self.state];      
    }
  }];
}

- (void)setViewsForState:(LSConversationHeaderState)state
{
  for(UIView *subview in [self subviews]) {
    [subview removeFromSuperview];
  }
  
  CGFloat labelMaxWidth = 200;
  
  UIButton *takenButton;
  UILabel *takenLabel;
  
  switch (state) {
    case LSConversationHeaderStateDefault:
      break;
    case LSConversationHeaderStateSeller:
      labelMaxWidth = 150;
      
      takenButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [takenButton addTarget:self action:@selector(markAsTaken:) forControlEvents:UIControlEventTouchUpInside];
      takenButton.backgroundColor = [UIColor whiteColor];
      [takenButton setTitleColor:[UIColor colorWithRed:0.900 green:0.247 blue:0.294 alpha:1.000] forState:UIControlStateNormal];
      [takenButton setTitleColor:[UIColor colorWithRed:0.900 green:0.247 blue:0.294 alpha:1.000] forState:UIControlStateHighlighted];
      [takenButton setTitle:@"Mark as taken" forState:UIControlStateNormal];
      takenButton.frame = CGRectMake(198, 12, 112, 26);
      takenButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
//      takenButton.titleLabel.textColor = [UIColor colorWithRed:0.900 green:0.247 blue:0.294 alpha:1.000];
//      takenButton.titleLabel.text = @"Mark as taken";
//      takenButton.titleLabel.backgroundColor = [UIColor clearColor];
      [self addSubview:takenButton];
      
      break;
    case LSConversationHeaderStateTaken:
      
      takenLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 13, 50, 25)];
      takenLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
      takenLabel.textColor = [UIColor colorWithWhite:0.537 alpha:1.000];
      takenLabel.text = @"Taken";
      takenLabel.textAlignment = NSTextAlignmentRight;
      takenLabel.backgroundColor = [UIColor clearColor];
      [self addSubview:takenLabel];
      
      break;
  }
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 6, labelMaxWidth, 18)];
  titleLabel.font = [UIFont boldSystemFontOfSize:15];
  titleLabel.textColor = [UIColor blackColor];
  titleLabel.text = [self.post objectForKey:kPostTitleKey];
  titleLabel.numberOfLines = 1;
  titleLabel.backgroundColor = [UIColor clearColor];
  [self addSubview:titleLabel];
  
  UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 26, labelMaxWidth, 14)];
  descriptionLabel.text = [self.post objectForKey:kPostDescriptionKey];
  descriptionLabel.font = [UIFont systemFontOfSize:12];
  descriptionLabel.textColor = [UIColor blackColor];
  descriptionLabel.numberOfLines = 1;
  descriptionLabel.backgroundColor = [UIColor clearColor];
  [self addSubview:descriptionLabel];
  
  PFFile *thumbnail = [self.post objectForKey:kPostThumbnailKey];
  
  // Only load if the url changes
  if (self.imageView.file.url != thumbnail.url) {
    self.imageView.file = thumbnail;
    [self.imageView loadInBackground];
  }
  [self addSubview:self.imageView];
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
