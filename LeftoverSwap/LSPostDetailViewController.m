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
@property (nonatomic) IBOutlet UIBarButtonItem *contactBarButtonItem;

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
  
  if ([[self.post objectForKey:kPostUserKey] isCurrentUser]) {
    [self.contactButton setTitle:@"Mark as taken" forState:UIControlStateNormal];
    self.contactButton.backgroundColor = [UIColor colorWithRed:0.929 green:0.110 blue:0.141 alpha:1];
    self.contactBarButtonItem.title = @"Mark as taken";
    self.contactBarButtonItem.tintColor = [UIColor colorWithRed:0.929 green:0.110 blue:0.141 alpha:1];
  }

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
  if (self.delegate) {
    if ([[self.post objectForKey:kPostUserKey] isCurrentUser]) {
      [self.delegate postDetailControllerDidMarkAsTaken:self forPost:self.post];
    } else {
      [self.delegate postDetailControllerDidContact:self forPost:self.post];
    }
  }
}

@end
