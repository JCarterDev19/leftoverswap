//
//  PAWViewController.m
//  Anywall
//
//  Created by Christopher Bowns on 1/30/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "LSLoginSignupViewController.h"

#import "LSLoginViewController.h"
#import "LSSignupViewController.h"

@interface LSLoginSignupViewController ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) NSArray *watermelons;
@property int arrayIndex;

@end

@implementation LSLoginSignupViewController

@synthesize delegate;

- (void)viewDidLoad
{
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenblock"]];
  
  NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
  
  {
    NSString *text = @"LeftoverSwap";
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:36.0f]];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - textSize.width)/2.0f, 180.0f, textSize.width, textSize.height)];
    [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:36.0f]];
    [textLabel setText:text];
    [textLabel setTextColor:[UIColor blackColor]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:UITextAlignmentCenter];
    
    [self.view addSubview:textLabel];
    
    self.watermelons = [[NSArray alloc] initWithObjects: @"plain2.png", @"plain3.png", @"plain4.png", @"plain.png", nil];
    self.arrayIndex = 3;
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.watermelons objectAtIndex:self.arrayIndex]]];
    CGRect logoFrame = CGRectMake((screenWidth/4.0f), 0.0f, (screenWidth/2.0f), 230.0f);
    [self.logoView setFrame:logoFrame];
    [self.logoView setContentMode:UIViewContentModeScaleAspectFit];
    [self.logoView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.logoView addGestureRecognizer:singleTap];
    [self.view addSubview:self.logoView];
  }
  {
    NSString *text = @"log in";
    CGSize dimens = CGSizeMake(240, 80);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((screenWidth - dimens.width)/2.0f, 260.0f, dimens.width, dimens.height)];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f)];
    [button addTarget:self action:@selector(loginButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:(19.0/255.0f) green:(128.0/255.0f) blue:(8.0/255.0f) alpha:1.0f]];
    
    [self.view addSubview:button];
  }
  {
    NSString *text = @"sign up";
    CGSize dimens = CGSizeMake(240, 80);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((screenWidth - dimens.width)/2.0f, 360.0f, dimens.width, dimens.height)];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f)];
    [button addTarget:self action:@selector(signUpSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:(19.0/255.0f) green:(128.0/255.0f) blue:(8.0/255.0f) alpha:1.0f]];
    
    [self.view addSubview:button];
  }
}

#pragma mark - Transition methods

- (IBAction)loginButtonSelected:(id)sender
{
	LSLoginViewController *loginViewController = [[LSLoginViewController alloc] initWithNibName:nil bundle:nil];
  loginViewController.delegate = self.delegate;
	[self presentViewController:loginViewController animated:YES completion:nil];
}

- (IBAction)signUpSelected:(id)sender
{
	LSSignupViewController *signupViewController = [[LSSignupViewController alloc] initWithNibName:nil bundle:nil];
  signupViewController.delegate = self.delegate;
	[self presentViewController:signupViewController animated:YES completion:nil];
}

- (void)imageTapped:(UIGestureRecognizer *)recognizer
{
  NSLog(@"tapped");
  NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
  self.logoView.image = nil;
  if (self.arrayIndex == 3) {
    self.arrayIndex = 0;
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.watermelons objectAtIndex:self.arrayIndex]]];
    NSLog(@"%i", self.arrayIndex);
    CGRect logoFrame = CGRectMake((screenWidth/4.0f), 0.0f, (screenWidth/2.0f), 230.0f);
    [self.logoView setFrame:logoFrame];
    [self.logoView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.logoView];
  } else if (self.arrayIndex == 0) {
    self.arrayIndex = 1;
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.watermelons objectAtIndex:self.arrayIndex]]];
    NSLog(@"%i", self.arrayIndex);
    CGRect logoFrame = CGRectMake((screenWidth/4.0f), 0.0f, (screenWidth/2.0f), 230.0f);
    [self.logoView setFrame:logoFrame];
    [self.logoView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.logoView];
  } else if (self.arrayIndex == 1) {
    self.arrayIndex = 2;
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.watermelons objectAtIndex:self.arrayIndex]]];
    NSLog(@"%i", self.arrayIndex);
    CGRect logoFrame = CGRectMake((screenWidth/4.0f), 0.0f, (screenWidth/2.0f), 230.0f);
    [self.logoView setFrame:logoFrame];
    [self.logoView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.logoView];
  } else if (self.arrayIndex == 2) {
    self.arrayIndex = 3;
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.watermelons objectAtIndex:self.arrayIndex]]];
    NSLog(@"%i", self.arrayIndex);
    CGRect logoFrame = CGRectMake((screenWidth/4.0f), 0.0f, (screenWidth/2.0f), 230.0f);
    [self.logoView setFrame:logoFrame];
    [self.logoView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.logoView];
  };
}

#pragma mark - targets


@end
