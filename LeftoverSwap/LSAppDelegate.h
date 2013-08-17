//
//  LSAppDelegate.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/23/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LSLocationController.h"
#import "LSWelcomeViewController.h"

@interface LSAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, LSWelcomeControllerDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic) LSLocationController *locationController;
@property (nonatomic, readonly) UIViewController *viewController;

@end
