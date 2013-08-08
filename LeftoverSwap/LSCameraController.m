//
//  LSCameraController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/7/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSCameraController.h"
#import "LSEditPhotoViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

@implementation LSCameraController

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [self dismissModalViewControllerAnimated:NO];
  
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  if (!image) {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
  }
  
  LSEditPhotoViewController *editPhotoController = [[LSEditPhotoViewController alloc] initWithNibName:nil bundle:nil image:image];
  [self.navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
  [self.navigationController pushViewController:editPhotoController animated:YES];
}

#pragma mark - ()

- (void)startCameraController {
  
  UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
  cameraUI.mediaTypes = @[(NSString*)kUTTypeImage];
  
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.showsCameraControls = YES;
    
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
  
  [self presentModalViewController:cameraUI animated:YES];
}

@end
