//
//  LSLoginViewController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/13/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

//
//  PAWLoginViewController.h
//  Anywall
//
//  Created by Christopher Bowns on 2/1/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSLoginSignupViewController.h"

@interface LSLoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) IBOutlet UITextField *usernameField;
@property (nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@property (nonatomic, weak) id<LSLoginControllerDelegate> delegate;

@end
