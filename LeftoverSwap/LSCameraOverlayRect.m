//
//  LSCameraOverlayRect.m
//  LeftoverSwap
//
//  Created by Dan Newman on 9/4/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSCameraOverlayRect.h"

@implementation LSCameraOverlayRect

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    self.opaque = NO;
    setBackgroundColor:[UIColor clearColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{ CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  CGRect rectangle = CGRectMake((screenWidth/6), (screenRect.origin.y + 50), (screenWidth-(screenWidth/3.0)), (screenHeight-(screenHeight/2.0)));
  CGContextRef context = UIGraphicsGetCurrentContext();
//  CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.0);   //this is the transparent color
  CGContextSetRGBStrokeColor(context, 0.411, 0.858, 0.509, .3);
  CGContextSetLineWidth(context, 2.0);
//  CGContextFillRect(context, rectangle);
  CGContextStrokeRect(context, rectangle);    //this will draw the border
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
