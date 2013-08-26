//
//  LSWelcomeViewController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/24/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSWelcomeViewController;

@protocol LSWelcomeControllerDelegate <NSObject>

- (void)welcomeControllerDidEat:(LSWelcomeViewController *)controller;
- (void)welcomeControllerDidFeed:(LSWelcomeViewController *)controller;

@end


@interface LSWelcomeViewController : UIViewController

@property (nonatomic, weak) id<LSWelcomeControllerDelegate> delegate;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) NSArray *watermelons;
@property int arrayIndex;
@end
