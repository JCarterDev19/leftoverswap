//
//  LSCameraController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/7/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSPostPhotoViewController.h"

/**
  HACK: this view controller exists so that we can insert it into the tar bar
 controller. We actually never create a view for this; instead, we present another
 view controller through presentCameraPickerController in the app delegate when 
 selecting this button's tab button.
 */
@interface LSCameraPresenterController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, LSPostPhotoViewControllerDelegate>

- (id)init;
- (void)presentCameraPickerController;

@end
