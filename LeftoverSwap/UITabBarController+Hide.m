//
//  UITabBarController+Hide.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/4/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "UITabBarController+Hide.h"

@implementation UITabBarController (Hide)

- (void)hideTabBar:(BOOL)isHidden
{
  NSArray *subviews = self.view.subviews;
  // Custom code to hide TabBar
  if ([subviews count] < 2 ) {
    return;
  }
  
  UIView *contentView;
  if ([[subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
    contentView = [subviews objectAtIndex:1];
  } else {
    contentView = [subviews objectAtIndex:0];
  }
  
  if (isHidden) {
    contentView.frame = self.view.bounds;
  } else {
    contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                   self.view.bounds.origin.y,
                                   self.view.bounds.size.width,
                                   self.view.bounds.size.height - self.tabBar.frame.size.height);
  }
  
  self.tabBar.hidden = isHidden;
}

@end
