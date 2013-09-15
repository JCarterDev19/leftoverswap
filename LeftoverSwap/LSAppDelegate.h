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

@interface LSAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic) LSLocationController *locationController;
@property (nonatomic, readonly) UIViewController *viewController;

- (BOOL)shouldDisplayWelcomeScreen;

@end
