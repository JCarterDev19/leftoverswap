//
//  LSTabBarController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/17/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSTabBarController.h"
#import "LSWelcomeViewController.h"
#import "LSLoginSignupViewController.h"
#import "LSLoginViewController.h"
#import "LSMapViewController.h"
#import "LSCameraPresenterController.h"
#import "LSConversationSummaryViewController.h"
#import "LSMeViewController.h"
#import "PFUser+PrivateChannelName.h"
#import "LSConstants.h"

@interface LSTabBarController ()

@property (nonatomic) LSCameraPresenterController *cameraController;

@end

@implementation LSTabBarController

@synthesize cameraController;

- (id)init
{
  self = [super init];
  if (self) {

    // It makes sense, right?
    self.delegate = self;

    LSMapViewController *mapViewController = [[LSMapViewController alloc] initWithNibName:nil bundle:nil];
    self.cameraController = [[LSCameraPresenterController alloc] init];
    LSConversationSummaryViewController *conversationController = [[LSConversationSummaryViewController alloc] init];
      LSMeViewController *meController = [[LSMeViewController alloc] init];
    
    self.viewControllers = @[mapViewController, cameraController, conversationController, meController];
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - instance methods

-(void)presentSignInView
{
  LSLoginSignupViewController *signInViewController = [[LSLoginSignupViewController alloc] initWithNibName:nil bundle:nil];
  signInViewController.delegate = self;
  [self presentViewController:signInViewController animated:NO completion:nil];
}

-(void)presentWelcomeView {
  LSWelcomeViewController *welcomeViewController = [[LSWelcomeViewController alloc] init];
  welcomeViewController.delegate = self;
  [self presentViewController:welcomeViewController animated:NO completion:nil];
}


#pragma mark - LSWelcomeControllerDelegate

-(void)welcomeControllerDidEat:(LSWelcomeViewController *)controller
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)welcomeControllerDidFeed:(LSWelcomeViewController *)controller
{
  [self dismissViewControllerAnimated:NO completion:nil];
  [self.cameraController presentCameraPickerController];
}

#pragma mark - LSLoginControllerDelegate

-(void)loginControllerDidFinish
{
  [self dismissViewControllerAnimated:YES completion:nil];
  
  PFUser *user = [PFUser currentUser];
  [[PFInstallation currentInstallation] addUniqueObject:[user privateChannelName] forKey:kLSInstallationChannelsKey];
  [[PFInstallation currentInstallation] saveEventually];
}

#pragma mark - UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)aViewController
{
  // Intercept tab event, and trigger its own modal UI instead
  if ([aViewController isKindOfClass:[LSCameraPresenterController class]]) {
    [(LSCameraPresenterController*)aViewController presentCameraPickerController];
    return NO;
  }
  return YES;
}

@end
