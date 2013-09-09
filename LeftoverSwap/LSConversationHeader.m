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

#define baseHorizontalOffset 20
#define baseWidth 280

#define horiBorderSpacing 6
#define horiMediumSpacing 8

#define vertBorderSpacing 6
#define vertSmallSpacing 2

#define imageX horiBorderSpacing
#define imageY vertBorderSpacing
#define imageDim 35

#define titleLabelX imageX+imageDim+horiMediumSpacing
#define titleLabelY vertBorderSpacing
#define titleLabelMaxWidth baseWidth - (horiBorderSpacing+imageDim+horiMediumSpacing+horiBorderSpacing)
#define titleLabelHeight 21

#define descriptionLabelX titleLabelX
#define descriptionLabelY titleLabelHeight+vertSmallSpacing
#define descriptionMaxWidth titleLabelMaxWidth
#define descriptionLabelHeight 22

@interface LSConversationHeader ()

@end

@implementation LSConversationHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor whiteColor];

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

  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelMaxWidth, titleLabelHeight)];
  titleLabel.font = [UIFont boldSystemFontOfSize:17];
  titleLabel.textColor = [UIColor blackColor];
  titleLabel.text = [self.post objectForKey:kPostTitleKey];
  titleLabel.numberOfLines = 1;
  titleLabel.backgroundColor = [UIColor clearColor];
  [self addSubview:titleLabel];
  
  NSString *descriptionString = [self.post objectForKey:kPostDescriptionKey];
  UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(descriptionLabelX, descriptionLabelY, descriptionMaxWidth, descriptionLabelHeight)];
  descriptionLabel.text = descriptionString;
  descriptionLabel.font = [UIFont systemFontOfSize:12];
  descriptionLabel.textColor = [UIColor blackColor];
  descriptionLabel.numberOfLines = 1;
  descriptionLabel.backgroundColor = [UIColor clearColor];
  [self addSubview:descriptionLabel];
  
  PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageDim, imageDim)];
  imageView.file = [self.post objectForKey:kPostThumbnailKey];
  imageView.backgroundColor = [UIColor blackColor];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  [imageView loadInBackground];
  [self addSubview:imageView];
  
  [self setNeedsDisplay];
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
