//
//  LSPostDetailViewController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/16/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class LSPostDetailViewController;

@protocol LSPostDetailDelegate <NSObject>

- (void)postDetailControllerDidMarkAsTaken:(LSPostDetailViewController*)postDetailController forPost:(PFObject*)post;
- (void)postDetailControllerDidContact:(LSPostDetailViewController *)postDetailController forPost:(PFObject*)post;

@end

@interface LSPostDetailViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil post:(PFObject*)post;

- (IBAction)cancel:(id)sender;
- (IBAction)contact:(id)sender;

@property (nonatomic, weak) id<LSPostDetailDelegate> delegate;

@end
