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
#import "LSConversationUtils.h"

@interface LSPostDetailViewController ()

@property (nonatomic) IBOutlet UIButton *contactButton;
@property (nonatomic) PFObject *post;
@property (nonatomic) PFUser *seller;

@end

static TTTTimeIntervalFormatter *timeFormatter;

@implementation LSPostDetailViewController

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLSPostTakenNotification object:nil];
}

- (id)initWithPost:(PFObject*)post
{
  self = [super init];
  if (self) {
    self.post = post;
    self.seller = [post objectForKey:kPostUserKey];
    
    if (!timeFormatter) {
      timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postWasTaken:) name:kLSPostTakenNotification object:nil];
  }
  return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSInteger adjustBottom = 548 - self.view.bounds.size.height;

  PFImageView *imageView = [[PFImageView alloc] initWithFrame:self.view.bounds];
  imageView.backgroundColor = [UIColor clearColor];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.file = [self.post objectForKey:kPostImageKey];
  [imageView loadInBackground];
  [self.view addSubview:imageView];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 352 - adjustBottom, 280, 21)];
  titleLabel.font = [UIFont boldSystemFontOfSize:17];
  titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
  titleLabel.text = [NSString stringWithFormat:@" %@", [self.post objectForKey:kPostTitleKey]];
  [self.view addSubview:titleLabel];
  
  UILabel *postDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 373 - adjustBottom, 280, 23)];
  postDetailsLabel.font = [UIFont systemFontOfSize:12];
  postDetailsLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
  [self.seller fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    NSString *postDate = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:self.post.createdAt];
    NSString *name = [self.seller objectForKey:kUserDisplayNameKey];
    postDetailsLabel.text = [NSString stringWithFormat:@" Posted by %@ about %@", name, postDate];
    [postDetailsLabel setNeedsDisplay];
  }];
  [self.view addSubview:postDetailsLabel];

  UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 396 - adjustBottom, 280, 47)];
  descriptionLabel.font = [UIFont systemFontOfSize:14];
  descriptionLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
  descriptionLabel.text = [NSString stringWithFormat:@" %@", [self.post objectForKey:kPostDescriptionKey]];
  descriptionLabel.numberOfLines = 0;
  [self.view addSubview:descriptionLabel];
  
  UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [contactButton addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
  contactButton.frame = CGRectMake(20, 451 - adjustBottom, 280, 44);
  contactButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
  self.contactButton = contactButton;
  [self.view addSubview:contactButton];
  
  [self setContactButtonStyle];
}

#pragma mark UINavigationBar-based actions

-(void)cancel:(id)sender
{
  [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)contact:(id)sender
{
  if ([[self.post objectForKey:kPostTakenKey] boolValue])
    return;
  
  if ([[self.post objectForKey:kPostUserKey] isCurrentUser]) {
    
    [self.post setObject:@(YES) forKey:kPostTakenKey];
    [self setContactButtonStyle];

    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (succeeded) {
        NSLog(@"Taken set for post %@", [self.post objectForKey:kPostTitleKey]);
        dispatch_async(dispatch_get_main_queue(), ^{
          [[NSNotificationCenter defaultCenter] postNotificationName:kLSPostTakenNotification object:self userInfo:@{kLSPostKey: self.post}];
          [LSConversationUtils sendTakenPushNotificationForPost:self.post];
        });
      } else {
        [self.post setObject:@(NO) forKey:kPostTakenKey];
        [self setContactButtonStyle];
      }
    }];

    if (self.delegate)
      [self.delegate postDetailControllerDidMarkAsTaken:self forPost:self.post];

  } else {
    if (self.delegate)
      [self.delegate postDetailControllerDidContact:self forPost:self.post];
  }
}

- (void)setContactButtonStyle
{
  NSString *title = nil;
  UIColor *backgroundColor = nil;
  if ([[self.post objectForKey:kPostTakenKey] boolValue]) {
    title = @"Taken";
    backgroundColor = [UIColor colorWithWhite:0.537 alpha:1.000];
  } else if ([[self.post objectForKey:kPostUserKey] isCurrentUser]) {
    title = @"Mark as taken";
    backgroundColor = [UIColor colorWithRed:0.900 green:0.247 blue:0.294 alpha:1.000];
  } else {
    title = @"contact";
    backgroundColor = [UIColor colorWithRed:0.357 green:0.844 blue:0.435 alpha:1.000];
  }
  [self.contactButton setTitle:title forState:UIControlStateNormal];
  self.contactButton.backgroundColor = backgroundColor;
}

- (void)postWasTaken:(NSNotification *)note
{
  if (note.object == self) return;

  PFObject *aPost = note.userInfo[kLSPostKey];
  if ([[self.post objectId] isEqualToString:[aPost objectId]]) {
    [self setContactButtonStyle];
  }
}

@end
