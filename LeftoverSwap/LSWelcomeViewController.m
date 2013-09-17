//
//  LSWelcomeViewController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/24/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSWelcomeViewController.h"
#import "LSAppDelegate.h"

@implementation LSWelcomeViewController

@synthesize delegate;
@synthesize logoView;
@synthesize watermelons;
@synthesize arrayIndex;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenblock"]];

  NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;

 {
   NSString *text = @"LeftoverSwap";
   CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:36.0f]];
   UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - textSize.width)/2.0f, 180.0f, textSize.width, textSize.height)];
 [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:36.0f]];
   [textLabel setText:text];
   [textLabel setTextColor:[UIColor blackColor]];
   [textLabel setBackgroundColor:[UIColor clearColor]];
   [textLabel setTextAlignment:UITextAlignmentCenter];
   
   [self.view addSubview:textLabel];
 

    
     watermelons = [[NSArray alloc] initWithObjects: @"plain2.png", @"plain3.png", @"plain4.png", @"plain.png", nil];
     arrayIndex = 3;
     logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[watermelons objectAtIndex:arrayIndex]]];
        CGRect logoFrame = CGRectMake((screenWidth/4.0f), 0.0f, (screenWidth/2.0f), 230.0f);
        [logoView setFrame:logoFrame];
         [logoView setContentMode:UIViewContentModeScaleAspectFit];
       [logoView setUserInteractionEnabled:YES];
     UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
     singleTap.numberOfTapsRequired = 1;
     singleTap.numberOfTouchesRequired = 1;
     [logoView addGestureRecognizer:singleTap];
      [self.view addSubview:logoView];

    }
  {
    NSString *text = @"eat";
    CGSize dimens = CGSizeMake(240, 80);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((screenWidth - dimens.width)/2.0f, 260.0f, dimens.width, dimens.height)];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f)];
    [button addTarget:self action:@selector(eatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:(19.0/255.0f) green:(128.0/255.0f) blue:(8.0/255.0f) alpha:1.0f]];
    
    [self.view addSubview:button];
  }

  {
    NSString *text = @"feed";
    CGSize dimens = CGSizeMake(240, 80);

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((screenWidth - dimens.width)/2.0f, 360.0f, dimens.width, dimens.height)];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [[button titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f)];
    [button addTarget:self action:@selector(feedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:(19.0/255.0f) green:(128.0/255.0f) blue:(8.0/255.0f) alpha:1.0f]];
    
    [self.view addSubview:button];
  }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - ()

- (void)eatButtonAction:(id)sender {
  [self.delegate welcomeControllerDidEat:self];
}

- (void)feedButtonAction:(id)sender {
  [self.delegate welcomeControllerDidFeed:self];
}

- (void)imageTapped:(UIGestureRecognizer *)recognizer
{
//    NSLog(@"tapped");
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    logoView.image = nil;
    if (arrayIndex == 3)
    {   arrayIndex = 0;
        logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[watermelons objectAtIndex:arrayIndex]]];
//        NSLog(@"%i", arrayIndex);
        CGRect logoFrame = CGRectMake((screenWidth/4.0f), 0.0f, (screenWidth/2.0f), 230.0f);
        [logoView setFrame:logoFrame];
        [logoView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:logoView];
        }
    else if (arrayIndex == 0)
    {   arrayIndex = 1;
        logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[watermelons objectAtIndex:arrayIndex]]];
//        NSLog(@"%i", arrayIndex);
        CGRect logoFrame = CGRectMake((screenWidth/4.0f), 0.0f, (screenWidth/2.0f), 230.0f);
        [logoView setFrame:logoFrame];
        [logoView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:logoView];
    }
      else if (arrayIndex == 1)
    {   arrayIndex = 2;
        logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[watermelons objectAtIndex:arrayIndex]]];
//        NSLog(@"%i", arrayIndex);
        CGRect logoFrame = CGRectMake((screenWidth/4.0f), 0.0f, (screenWidth/2.0f), 230.0f);
        [logoView setFrame:logoFrame];
        [logoView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:logoView];
    }
       else if (arrayIndex == 2)
    {   arrayIndex = 3;
        logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[watermelons objectAtIndex:arrayIndex]]];
//        NSLog(@"%i", arrayIndex);
        CGRect logoFrame = CGRectMake((screenWidth/4.0f), 0.0f, (screenWidth/2.0f), 230.0f);
        [logoView setFrame:logoFrame];
        [logoView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:logoView];
    };
}




@end
