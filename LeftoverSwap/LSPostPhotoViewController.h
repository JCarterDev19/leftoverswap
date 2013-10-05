//
//  LSPostPhotoViewController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/8/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

@class LSPaddedTextField;

@class LSPostPhotoViewController;

@protocol LSPostPhotoViewControllerDelegate <NSObject>

- (void)postPhotoControllerDidFinishPosting:(LSPostPhotoViewController *)post;
- (void)postPhotoControllerDidCancel:(LSPostPhotoViewController *)post;

@end

@interface LSPostPhotoViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property (nonatomic) UIImage *image;
@property (nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet LSPaddedTextField *titleTextField;
@property (nonatomic) IBOutlet UITextView *descriptionTextView;
@property (nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (nonatomic, weak) id<LSPostPhotoViewControllerDelegate> delegate;

- (IBAction)cancelPost:(id)sender;
- (IBAction)postPost:(id)sender;

@end
