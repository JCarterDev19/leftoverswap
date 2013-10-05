//
//  LSSignupViewController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 9/13/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

//
//  PAWNewUserViewController.m
//  Anywall
//
//  Created by Christopher Bowns on 2/1/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "LSSignupViewController.h"

#import <Parse/Parse.h>
#import "LSActivityView.h"
#import "LSMapViewController.h"

@interface LSSignupViewController ()

- (void)processFieldEntries;
- (void)textInputChanged:(NSNotification *)note;
- (BOOL)shouldEnableDoneButton;

@end

@implementation LSSignupViewController

@synthesize doneButton;
@synthesize usernameField;
@synthesize passwordField;
@synthesize passwordAgainField;
@synthesize emailField;

@synthesize delegate;

#pragma mark - UIViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification object:usernameField];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification object:passwordField];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification object:passwordAgainField];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification object:emailField];
  
	doneButton.enabled = NO;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:usernameField];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:passwordField];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:passwordAgainField];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:emailField];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == usernameField) {
		[passwordField becomeFirstResponder];
	} else if (textField == passwordField) {
		[passwordAgainField becomeFirstResponder];
	} else if (textField == passwordAgainField) {
		[emailField becomeFirstResponder];
	} else if (textField == emailField) {
    [emailField resignFirstResponder];
    [self processFieldEntries];
  }

	return YES;
}

#pragma mark - ()

- (BOOL)shouldEnableDoneButton
{
	BOOL enableDoneButton = NO;
	if (usernameField.text != nil &&
		usernameField.text.length > 0 &&
		passwordField.text != nil &&
		passwordField.text.length > 0 &&
		passwordAgainField.text != nil &&
		passwordAgainField.text.length > 0 &&
    emailField.text != nil &&
    emailField.text.length > 0) {
		enableDoneButton = YES;
	}
	return enableDoneButton;
}

- (void)textInputChanged:(NSNotification *)note
{
	doneButton.enabled = [self shouldEnableDoneButton];
}

- (IBAction)cancel:(id)sender
{
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	[passwordAgainField resignFirstResponder];
  [emailField resignFirstResponder];
	[self processFieldEntries];
}

- (void)processFieldEntries
{
	// Check that we have a non-zero username and passwords.
	// Compare password and passwordAgain for equality
	// Throw up a dialog that tells them what they did wrong if they did it wrong.

	NSString *username = usernameField.text;
	NSString *password = passwordField.text;
	NSString *passwordAgain = passwordAgainField.text;
  NSString *email = emailField.text;
	NSString *errorText = @"Please ";
	NSString *usernameBlankText = @"enter a username";
	NSString *passwordBlankText = @"enter a password";
  NSString *emailBlankText = @"enter an email address";
	NSString *joinText = @", and ";
	NSString *passwordMismatchText = @"enter the same password twice";

	BOOL textError = NO;

	// Messaging nil will return 0, so these checks implicitly check for nil text.
	if (username.length == 0 || password.length == 0 || passwordAgain.length == 0 || email.length == 0) {
		textError = YES;

		// Set up the keyboard for the first field missing input:
    if (email.length == 0) {
      [emailField becomeFirstResponder];
    }

		if (passwordAgain.length == 0) {
			[passwordAgainField becomeFirstResponder];
		}
		if (password.length == 0) {
			[passwordField becomeFirstResponder];
		}
		if (username.length == 0) {
			[usernameField becomeFirstResponder];
		}

    BOOL anyErrors = NO;
		if (username.length == 0) {
			errorText = [errorText stringByAppendingString:usernameBlankText];
      anyErrors = YES;
		} else if (email.length == 0) {
      errorText = [errorText stringByAppendingString:emailBlankText];
      anyErrors = YES;
    }

		if (password.length == 0 || passwordAgain.length == 0) {
			if (anyErrors) { // We need some joining text in the error:
				errorText = [errorText stringByAppendingString:joinText];
			}
			errorText = [errorText stringByAppendingString:passwordBlankText];
		}
	} else if ([password compare:passwordAgain] != NSOrderedSame) {
		// We have non-zero strings.
		// Check for equal password strings.
		textError = YES;
		errorText = [errorText stringByAppendingString:passwordMismatchText];
		[passwordField becomeFirstResponder];
	}

	if (textError) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		return;
	}

	// Everything looks good; try to log in.
	// Disable the done button for now.
	doneButton.enabled = NO;
	LSActivityView *activityView = [[LSActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
	UILabel *label = activityView.label;
	label.text = @"Signing You Up";
	label.font = [UIFont boldSystemFontOfSize:20.f];
	[activityView.activityIndicator startAnimating];
	[activityView layoutSubviews];

	[self.view addSubview:activityView];

	// Call into an object somewhere that has code for setting up a user.
	// The app delegate cares about this, but so do a lot of other objects.
	// For now, do this inline.

	PFUser *user = [PFUser user];
	user.username = username;
	user.password = password;
  user.email = email;

	[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[alertView show];
			doneButton.enabled = [self shouldEnableDoneButton];
			[activityView.activityIndicator stopAnimating];
			[activityView removeFromSuperview];
			// Bring the keyboard back up, because they'll probably need to change something.
			[usernameField becomeFirstResponder];
			return;
		}

		// Success!
		[activityView.activityIndicator stopAnimating];
		[activityView removeFromSuperview];
    
    [self.delegate signupControllerDidFinish:self];
	}];
}

@end
