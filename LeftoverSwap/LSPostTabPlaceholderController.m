//
//  LSCameraController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/7/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSPostTabPlaceholderController.h"
#import "LSTabBarController.h"
#import "LSMapViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface LSPostTabPlaceholderController ()

@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation LSPostTabPlaceholderController

@synthesize imagePickerController;

- (id)init
{
  self = [super init];
  if (self) {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Post" image:[UIImage imageNamed:@"TabBarPost.png"] tag:1];
  }
  return self;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  if (!image) {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
  }

  // presenting another VC from a UIPickerController will never set the status bar back to its original state.
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PostPhoto" bundle:nil];
  UINavigationController *navController = [sb instantiateInitialViewController];
  LSPostPhotoViewController *postPhotoController = (LSPostPhotoViewController*)navController.topViewController;
  postPhotoController.image = image;
  postPhotoController.delegate = self;
  
  [imagePickerController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
  [imagePickerController presentViewController:navController animated:YES completion:nil];
}

#pragma mark - ()

- (UIImagePickerController*)imagePickerController
{
  UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
  cameraUI.mediaTypes = @[(NSString*)kUTTypeImage];
  
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
  
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.showsCameraControls = YES;
//    cameraUI.cameraOverlayView = [[LSCameraOverlayRect alloc] initWithFrame:self.view.bounds];
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
      cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
      cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    // Some iPods, simulator: use the Camera's photo roll
  } else {
    //    NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;    
    NSAssert([UIImagePickerController isSourceTypeAvailable:sourceType]
             && [[UIImagePickerController availableMediaTypesForSourceType:sourceType] containsObject:(NSString *)kUTTypeImage], @"Device must support photo rolls");
    cameraUI.sourceType = sourceType;
  }
  
  cameraUI.allowsEditing = NO;
  cameraUI.delegate = self;
  
  return self.imagePickerController = cameraUI;
}

#pragma mark - LSPostPhotoViewControllerDelegate

-(void)postPhotoControllerDidCancel:(LSPostPhotoViewController *)post
{
  [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

- (void)postPhotoControllerDidFinishPosting:(LSPostPhotoViewController *)post
{
  self.tabBarController.selectedViewController = ((LSTabBarController*)self.tabBarController).mapViewController;
  [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}


@end
