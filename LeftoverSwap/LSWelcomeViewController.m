//
//  LSWelcomeViewController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/24/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSWelcomeViewController.h"
#import "LSAppDelegate.h"

@implementation LSWelcomeViewController

- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"welcome"]];
  
  NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;

//  {
//    NSString *text = @"LeftoverSwap";
//    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:36.0f]];
//    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake( (screenWidth - textSize.width)/2.0f, 200.0f, textSize.width, textSize.height)];
//    [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:36.0f]];
//    [textLabel setText:text];
//    [textLabel setTextColor:[UIColor blackColor]];
//    [textLabel setBackgroundColor:[UIColor clearColor]];
//    [textLabel setTextAlignment:UITextAlignmentCenter];
//    
//    [self.view addSubview:textLabel];
//  }

  {
    NSString *text = @"Eat";
    CGSize dimens = CGSizeMake(240, 80);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((screenWidth - dimens.width)/2.0f, 260.0f, dimens.width, dimens.height)];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:28.0f]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f)];
    [button addTarget:self action:@selector(eatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:button];
  }

  {
    NSString *text = @"Feed";
    CGSize dimens = CGSizeMake(240, 80);

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((screenWidth - dimens.width)/2.0f, 360.0f, dimens.width, dimens.height)];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:28.0f]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f)];
    [button addTarget:self action:@selector(feedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:button];
  }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - ()

- (void)eatButtonAction:(id)sender {
  [(LSAppDelegate*)[[UIApplication sharedApplication] delegate] presentMainInterface];
}

- (void)feedButtonAction:(id)sender {
  
}

@end
