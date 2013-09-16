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

@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@property (nonatomic, weak) id<LSLoginControllerDelegate> delegate;

@end
