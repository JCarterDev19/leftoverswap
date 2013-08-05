//
//  LSPaddedTextField.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/4/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSPaddedTextField.h"

@implementation LSPaddedTextField

@synthesize leftRightPadding;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    leftRightPadding = 0.0f;
  }
  return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, leftRightPadding, leftRightPadding);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return [self textRectForBounds:bounds];
}

@end
