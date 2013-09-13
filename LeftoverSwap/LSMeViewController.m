//
//  LSMeViewController.m
//  LeftoverSwap
//
//  Created by Dan Newman on 9/4/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSMeViewController.h"
#import "LSLoginSignupViewController.h"
#import "LSTabBarController.h"
#import "LSAppDelegate.h"
#import "LSConstants.h"

@interface LSMeViewController ()

@property (nonatomic) IBOutlet UILabel *userLabel;
@property (nonatomic) PFUser *user;

@end

@implementation LSMeViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:[UIImage imageNamed:@"TabBarMe"] tag:2];
  }
  return self;
}

- (void)viewDidLoad
{
  self.navigationItem.title = [[PFUser currentUser] objectForKey:kUserDisplayNameKey];
  self.navigationItem.leftBarButtonItem = nil;
//  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPost:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStyleDone target:self action:@selector(logout:)];
}

- (IBAction)logout:(id)sender
{
  [PFUser logOut];
  [(LSTabBarController*)self.tabBarController presentSignInView];
}

- (IBAction)TOSbutton:(id)sender
{
//  NSURL *currentURL = [NSURL URLWithString:@"http://www.leftoverswap.com/TOS.html"];
//  UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//  [webView loadRequest:[NSURLRequest requestWithURL:currentURL]];
//  [self.view addSubview:webView];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.leftoverswap.com/tos.html"]];
}

@end
