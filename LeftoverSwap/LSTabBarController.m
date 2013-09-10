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
@property (nonatomic) UINavigationController *conversationNavigationController;
@property (nonatomic) LSConversationSummaryViewController *conversationSummaryController;

@end

@implementation LSTabBarController

@synthesize cameraController;
@synthesize conversationNavigationController;
@synthesize conversationSummaryController;

- (id)init
{
  self = [super init];
  if (self) {

    // It makes sense, right?
    self.delegate = self;

    LSMapViewController *mapViewController = [[LSMapViewController alloc] initWithNibName:nil bundle:nil];
    self.cameraController = [[LSCameraPresenterController alloc] init];
    
    self.conversationSummaryController = [[LSConversationSummaryViewController alloc] init];
    self.conversationNavigationController = [[UINavigationController alloc] initWithRootViewController:self.conversationSummaryController];

    LSMeViewController *meController = [[LSMeViewController alloc] init];
    
    self.viewControllers = @[mapViewController, cameraController, conversationNavigationController, meController];
  }
  return self;
}

#pragma mark - instance methods

-(void)presentSignInView
{
  LSLoginSignupViewController *signInViewController = [[LSLoginSignupViewController alloc] initWithNibName:nil bundle:nil];
  signInViewController.delegate = self;
  [self presentViewController:signInViewController animated:NO completion:nil];
}

-(void)presentWelcomeView
{
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

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)aViewController
{
  // Intercept tab event, and trigger its own modal UI instead
  if ([aViewController isKindOfClass:[LSCameraPresenterController class]]) {
    [(LSCameraPresenterController*)aViewController presentCameraPickerController];
    return NO;
  }
  return YES;
}

#pragma mark - LSNewConversationDelegate

- (void)conversationController:(LSNewConversationViewController *)conversation didSendText:(NSString *)text forPost:(PFObject *)post
{
  // TODO: set conversation view controller w/ conversation summary controller
  // and present this to the end of a view.

  self.selectedViewController = self.conversationNavigationController;
  [self.conversationSummaryController addNewConversation:text forPost:post];

  self.presentedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - LSPostDetailViewController

- (void)postDetailControllerDidContact:(LSPostDetailViewController *)postDetailController forPost:(PFObject*)post
{
  LSNewConversationViewController *conversationController = [[LSNewConversationViewController alloc] initWithPost:post];
  conversationController.conversationDelegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:conversationController];
  [postDetailController presentViewController:navigationController animated:YES completion:nil];
}

@end
