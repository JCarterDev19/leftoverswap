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

@interface LSPostDetailViewController ()

@property (nonatomic) IBOutlet PFImageView *imageView;
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UILabel *sellerLabel;
@property (nonatomic) IBOutlet UILabel *postDateLabel;
@property (nonatomic) IBOutlet UITextView *description;

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
      
//      self.imageView.image = [UIImage imageNamed:@"PlaceholderPhoto.png"];
      self.imageView.backgroundColor = [UIColor blackColor];
      self.imageView.contentMode = UIViewContentModeScaleAspectFit;
      self.imageView.file = [post objectForKey:kPostImageKey];
      
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
  
  [self.imageView loadInBackground:^(UIImage *image, NSError *error) {
    NSLog(@"%@ load image", error ? @"Did" : @"Didn't");
  }];
  
  self.titleLabel.text = [post objectForKey:kPostTitleKey];
  
  [self.seller fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    NSString *name = [self.seller objectForKey:kUserDisplayNameKey];
    self.sellerLabel.text = name;
    [sellerLabel setNeedsDisplay];
  }];
  
  self.postDateLabel.text = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[post createdAt]];
  
  self.description.text = [post objectForKey:kPostDescriptionKey];
}

#pragma mark UINavigationBar-based actions

-(void)cancel:(id)sender
{
  [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)contact:(id)sender
{
  NSLog(@"You contacted the sender!");
  
  [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

@end
