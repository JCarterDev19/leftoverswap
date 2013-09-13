//
//  LSPostDetailViewController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/16/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSPostDetailViewController.h"
#import "LSConstants.h"
#import "TTTTimeIntervalFormatter.h"
#import "LSTabBarController.h"
#import "PFObject+Utilities.h"

@interface LSPostDetailViewController ()

@property (nonatomic) IBOutlet PFImageView *imageView;
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UILabel *sellerLabel;
@property (nonatomic) IBOutlet UILabel *postDateLabel;
@property (nonatomic) IBOutlet UITextView *description;
@property (nonatomic) IBOutlet UIButton *contactButton;
//@property (nonatomic) IBOutlet UIBarButtonItem *contactBarButtonItem;

@property (nonatomic) PFObject *post;
@property (nonatomic) PFUser *seller;

@end

static TTTTimeIntervalFormatter *timeFormatter;

@implementation LSPostDetailViewController

@synthesize imageView;
@synthesize titleLabel;
@synthesize sellerLabel;
@synthesize postDateLabel;
@synthesize description;

@synthesize post;
@synthesize seller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil post:(PFObject*)aPost
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.post = aPost;
      self.seller = [aPost objectForKey:kPostUserKey];
      
      if (!timeFormatter) {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
      }

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self setContactButtonView];

  self.imageView.backgroundColor = [UIColor clearColor];
  self.imageView.contentMode = UIViewContentModeScaleAspectFill;
  self.imageView.file = [self.post objectForKey:kPostImageKey];
  
  [self.imageView loadInBackground];
    NSString *postTitle = [self.post objectForKey:kPostTitleKey];
    self.titleLabel.text = [NSString stringWithFormat:@" %@", postTitle];
  
//  [self.seller fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//   NSString *name = [self.seller objectForKey:kUserDisplayNameKey];
//   self.sellerLabel.text = [NSString stringWithFormat:@"Posted by %@", name];
//    [self.sellerLabel setNeedsDisplay];
//  }];

    NSString *postDate = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[self.post createdAt]];
  
//  self.postDateLabel.text = [NSString stringWithFormat:@"about %@", postDate];
  
    [self.seller fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSString *name = [self.seller objectForKey:kUserDisplayNameKey];
    self.sellerLabel.text = [NSString stringWithFormat:@" Posted by %@ about %@", name, postDate];
            [self.sellerLabel setNeedsDisplay];
    }];
  
  self.description.text = [self.post objectForKey:kPostDescriptionKey];
}

#pragma mark UINavigationBar-based actions

-(void)cancel:(id)sender
{
  [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)contact:(id)sender
{
  if ([[self.post objectForKey:kPostTakenKey] boolValue]) {
    return;
  } else if ([[self.post objectForKey:kPostUserKey] isCurrentUser]) {
    [self.post setObject:@(YES) forKey:kPostTakenKey];
    [self setContactButtonView];
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (succeeded) {
        NSLog(@"Taken set for post %@", [self.post objectForKey:kPostTitleKey]);
      } else {
        [self.post setObject:@(NO) forKey:kPostTakenKey];
        [self setContactButtonView];
      }
    }];
    if (self.delegate)
      [self.delegate postDetailControllerDidMarkAsTaken:self forPost:self.post];
  } else {
    if (self.delegate)
      [self.delegate postDetailControllerDidContact:self forPost:self.post];
  }
}

- (void)setContactButtonView
{
  if ([[self.post objectForKey:kPostTakenKey] boolValue]) {
    [self.contactButton setTitle:@"Taken" forState:UIControlStateNormal];
    self.contactButton.backgroundColor = [UIColor colorWithWhite:0.537 alpha:1.000];
//    self.navigationItem.rightBarButtonItem = nil;
//    self.contactBarButtonItem.title = @"Taken";
//    self.contactBarButtonItem.tintColor = [UIColor colorWithWhite:0.537 alpha:1.000];
  } else if ([[self.post objectForKey:kPostUserKey] isCurrentUser]) {
    [self.contactButton setTitle:@"Mark as taken" forState:UIControlStateNormal];
    self.contactButton.backgroundColor = [UIColor colorWithRed:0.900 green:0.247 blue:0.294 alpha:1.000];
    
    // re-add this, as we could've removed it previously
//    self.navigationItem.rightBarButtonItem = self.contactBarButtonItem;
//    self.contactBarButtonItem.title = @"Mark as taken";
//    self.contactBarButtonItem.tintColor = [UIColor colorWithRed:0.900 green:0.247 blue:0.294 alpha:1.000];
  }
}

@end
