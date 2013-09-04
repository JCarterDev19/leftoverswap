//
//  LSMeViewController.m
//  LeftoverSwap
//
//  Created by Dan Newman on 9/4/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSMeViewController.h"
#import "LSConstants.h"

@interface LSMeViewController ()
@property (nonatomic) IBOutlet UILabel *userLabel;
@property (nonatomic) PFUser *user;
@end

@implementation LSMeViewController;
@synthesize userLabel;
@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:[UIImage imageNamed:@"TabBarMe"] tag:2];}

        return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        PFUser *currentUser= [PFUser currentUser];
        NSString *name = [currentUser objectForKey:kUserDisplayNameKey];
        self.userLabel.text = [NSString stringWithFormat:@"%@", name];



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
