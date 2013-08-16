//
//  LSPostDetailViewController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/16/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LSPostDetailViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil post:(PFObject*)post;

- (IBAction)cancel:(id)sender;
- (IBAction)contact:(id)sender;

@end
