//
//  LSLoginSignupViewController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/13/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

//
//  PAWViewController.h
//  Anywall
//
//  Created by Christopher Bowns on 1/30/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSLoginViewController, LSSignupViewController;

@protocol LSLoginControllerDelegate <NSObject>

- (void)loginControllerDidFinish:(LSLoginViewController*)loginController;
- (void)signupControllerDidFinish:(LSSignupViewController*)signupController;

@end

@interface LSLoginSignupViewController : UIViewController

- (IBAction)loginButtonSelected:(id)sender;
- (IBAction)signUpSelected:(id)sender;

@property (nonatomic, weak) id<LSLoginControllerDelegate> delegate;

@end
