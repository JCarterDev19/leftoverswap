//
//  LSViewController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/23/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSViewController.h"
#import <Parse/Parse.h>

@interface LSViewController ()

@end

@implementation LSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  PFObject *testObject = [PFObject objectWithClassName:@"Test"];
  [testObject setObject:@"bar" forKey:@"foo"];
  BOOL didSave = [testObject save];
  NSLog(@"%@ was %@", testObject, didSave ? @"saved" : @"not saved");
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
