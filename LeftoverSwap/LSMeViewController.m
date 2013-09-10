//
//  LSMeViewController.m
//  LeftoverSwap
//
//  Created by Dan Newman on 9/4/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSMeViewController.h"
#import "LSConstants.h"
#import "LSLoginSignupViewController.h"
#import "LSAppDelegate.h"

@interface LSMeViewController ()
@property (nonatomic) IBOutlet UILabel *userLabel;
@property (nonatomic) PFUser *user;
@end

@implementation LSMeViewController;
@synthesize userLabel;
@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:[UIImage imageNamed:@"TabBarMe"] tag:2];}

        return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        PFUser *currentUser= [PFUser currentUser];
        NSString *name = [currentUser objectForKey:kUserDisplayNameKey];
        self.userLabel.text = [NSString stringWithFormat:@" %@", name];



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButton:(id)sender {
  [PFUser logOut];
  //FIXME: after logging out, and logging in or signing up, the login and signup view remains undismissed.
  LSLoginSignupViewController *loginSignupViewController = [[LSLoginSignupViewController alloc] initWithNibName:nil bundle:nil];
  
	[self presentViewController:loginSignupViewController animated:YES completion:nil];

}

- (IBAction)TOSbutton:(id)sender {
//  NSURL *currentURL = [NSURL URLWithString:@"http://www.leftoverswap.com/TOS.html"];
//  UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//  [webView loadRequest:[NSURLRequest requestWithURL:currentURL]];
//  [self.view addSubview:webView];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.leftoverswap.com/tos.html"]];
}

@end
