//
//  PAWViewController.h
//  Anywall
//
//  Created by Christopher Bowns on 1/30/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSLoginControllerDelegate <NSObject>

- (void)loginControllerDidFinish;

@end

@interface LSLoginSignupViewController : UIViewController

- (IBAction)loginButtonSelected:(id)sender;
- (IBAction)signUpSelected:(id)sender;

@property (nonatomic, weak) id<LSLoginControllerDelegate> delegate;

@end
