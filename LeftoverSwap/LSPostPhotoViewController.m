//
//  PAPEditPhotoViewController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//

#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#import "LSAppDelegate.h"
#import "LSLocationController.h"
#import "LSConstants.h"
#import "LSPostPhotoViewController.h"
#import "LSPaddedTextField.h"
#import "UIImage+ResizeAdditions.h"

@interface LSPostPhotoViewController ()

@property (nonatomic) UIImage *image;

@property PFFile *photoFile;
@property PFFile *thumbnailFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;

-(UIView*)findEmptyViews;

@end

@implementation LSPostPhotoViewController

@synthesize scrollView;
@synthesize imageView;
@synthesize titleTextField;
@synthesize descriptionTextView;
@synthesize postButton;

@synthesize image;

@synthesize delegate;

@synthesize photoFile;
@synthesize thumbnailFile;
@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId;

#pragma mark - NSObject

- (void)dealloc {
//  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)aImage {
  self = [super initWithNibName:NSStringFromClass(self.class) bundle:nibBundleOrNil];
  if (self) {
    if (!aImage) {
      return nil;
    }
    
    self.image = aImage;
    
    self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
    self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    
  }
  return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"Memory warning on Edit");
}


#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.scrollView.delegate = self;
  self.scrollView.scrollEnabled = NO;

  [self.navigationItem setHidesBackButton:YES];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPost:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(postPost:)];
  
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextViewTextDidChangeNotification object:nil];
  
  titleTextField.delegate = self;
  descriptionTextView.delegate = self;
  
  titleTextField.leftRightPadding = 8.0f;

  // Adding image view properties
  self.imageView.image = self.image;
  [self.imageView setClipsToBounds:YES];

  [self shouldUploadImage:self.image];
  
  [titleTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.descriptionTextView becomeFirstResponder];
  return YES;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//  [self.scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(textView.frame)) animated:YES];
  return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//  [self.titleTextField resignFirstResponder];
//  [self.descriptionTextView resignFirstResponder];
}


#pragma mark - ()

- (BOOL)shouldUploadImage:(UIImage *)anImage {
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];

    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    NSLog(@"Requested background expiration task with id %d for LeftoverSwap photo upload", self.fileUploadBackgroundTaskId);
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded successfully");
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Thumbnail uploaded successfully");
                }
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
  
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)note {
  CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGSize scrollViewContentSize = self.scrollView.bounds.size;
  scrollViewContentSize.height += keyboardFrameEnd.size.height;
  [self.scrollView setContentSize:scrollViewContentSize];
  
  CGPoint scrollViewContentOffset = self.scrollView.contentOffset;
  scrollViewContentOffset.y += keyboardFrameEnd.size.height;
  [self.scrollView setContentOffset:scrollViewContentOffset animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)note {
  CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGSize scrollViewContentSize = self.scrollView.bounds.size;
  scrollViewContentSize.height -= keyboardFrameEnd.size.height;
  [UIView animateWithDuration:0.200f animations:^{
    [self.scrollView setContentSize:scrollViewContentSize];
  }];
}

- (IBAction)postPost:(id)sender {
  [titleTextField resignFirstResponder];
  [descriptionTextView resignFirstResponder];
  
  UIView *emptyView = [self findEmptyViews];
  
  if (emptyView) {
		[emptyView becomeFirstResponder];
		return;
	}
  
  //NSDictionary *userInfo = [NSDictionary dictionary];
  NSString *trimmedTitle = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  NSString *trimmedDescription = [self.descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  if (!self.photoFile || !self.thumbnailFile) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
    [alert show];
    return;
  }
  
  // both files have finished uploading
  if (![PFUser currentUser]) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"user must be logged in to post" userInfo:nil];
  }
  
  // create a photo object
  PFObject *post = [PFObject objectWithClassName:kPostClassKey];
  [post setObject:[PFUser currentUser] forKey:kPostUserKey];
  [post setObject:self.photoFile forKey:kPostImageKey];
  [post setObject:self.thumbnailFile forKey:kPostThumbnailKey];
  [post setObject:trimmedDescription forKey:kPostDescriptionKey];
  [post setObject:trimmedTitle forKey:kPostTitleKey];
  [post setObject:[self currentLocation] forKey:kPostLocationKey];
  
  // photos are public, but may only be modified by the user who uploaded them
  PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
  [photoACL setPublicReadAccess:YES];
  post.ACL = photoACL;
  
  // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
  self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
  }];

  // save
  [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      NSLog(@"Photo uploaded");
      
      NSLog(@"Successfully saved!");
			NSLog(@"%@", post);
			dispatch_async(dispatch_get_main_queue(), ^{
				[[NSNotificationCenter defaultCenter] postNotificationName:kLSPostCreatedNotification object:nil];
			});
    } else {
      NSLog(@"Photo failed to save: %@", error);
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
      [alert show];
    }
    [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
  }];

  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLSPostCreatedNotification object:nil userInfo:@{kLSPostKey: post}];
  });

  if (self.delegate && [self.delegate respondsToSelector:@selector(postPhotoControllerDidFinishPosting:)]) {


    [delegate postPhotoControllerDidFinishPosting:self];
  }
}

- (IBAction)cancelPost:(id)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(postPhotoControllerDidCancel:)]) {
    [delegate postPhotoControllerDidCancel:self];
  }
}

#pragma mark UITextView nofitication methods

- (void)textInputChanged:(NSNotification *)note {
  postButton.enabled = [self findEmptyViews] == nil;
}

#pragma mark Private helper methods

-(PFGeoPoint*)currentLocation {
  LSAppDelegate *appDelegate = (LSAppDelegate*)[[UIApplication sharedApplication] delegate];
  CLLocationCoordinate2D currentCoordinate = appDelegate.locationController.currentLocation.coordinate;
	PFGeoPoint *currentPoint = [PFGeoPoint geoPointWithLatitude:currentCoordinate.latitude longitude:currentCoordinate.longitude];
  return currentPoint;
}

-(UIView*)findEmptyViews {
  if (titleTextField.text.length == 0) {
    return titleTextField;
  } else if (descriptionTextView == 0) {
    return descriptionTextView;
  } else {
    return nil;
  }
}

@end
