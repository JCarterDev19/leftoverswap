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

@interface LSTabBarController ()

@end

@implementation LSTabBarController

- (id)init
{
  self = [super init];
  if (self) {

    // It makes sense, right?
    self.delegate = self;

    LSMapViewController *mapViewController = [[LSMapViewController alloc] initWithNibName:nil bundle:nil];
    LSCameraPresenterController *cameraController = [[LSCameraPresenterController alloc] init];
    LSConversationSummaryViewController *conversationController = [[LSConversationSummaryViewController alloc] init];
    
    self.viewControllers = @[mapViewController, cameraController, conversationController];
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
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LSLoginControllerDelegate

-(void)loginControllerDidFinish
{
  [self dismissViewControllerAnimated:YES completion:nil];
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
