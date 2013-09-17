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

@implementation LSLoginSignupViewController

@synthesize delegate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
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

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - targets

- (IBAction)termsOfService:(id)sender
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.leftoverswap.com/tos.html"]];
}

@end
