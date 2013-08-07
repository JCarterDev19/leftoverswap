//
//  PAPEditPhotoViewController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//

#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#import "LSConstants.h"
#import "LSEditPhotoViewController.h"
#import "LSPaddedTextField.h"
#import "UIImage+ResizeAdditions.h"

@interface LSEditPhotoViewController ()

@property (nonatomic) UIImage *image;

@property PFFile *photoFile;
@property PFFile *thumbnailFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;

-(UIView*)findEmptyViews;

@end

@implementation LSEditPhotoViewController

@synthesize scrollView;
@synthesize imageView;
@synthesize titleTextField;
@synthesize descriptionTextView;
@synthesize postButton;

@synthesize image;

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
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStyleDone target:self action:@selector(postPost:)];
  
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
  
//    NSDictionary *userInfo = [NSDictionary dictionary];
  NSString *trimmedTitle = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  NSString *trimmedDescription = [self.descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

//    if (trimmedComment.length != 0) {
//        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  trimmedComment,kPhotoComment,
//                                  nil];
//    }
  
    if (!self.photoFile || !self.thumbnailFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    // both files have finished uploading
    
    // create a photo object
//    PFObject *photo = [PFObject objectWithClassName:kPostClassKey];
//    [photo setObject:[PFUser currentUser] forKey:kPostUserKey];
//    [photo setObject:self.photoFile forKey:kPostImageKey];
//    [photo setObject:self.thumbnailFile forKey:kPostThumbnailKey];
//    [photo setObject:trimmedDescription forKey:kPostDescriptionKey];
//    [photo setObject:trimmedTitle forKey:kPostTitleKey];

  
    // photos are public, but may only be modified by the user who uploaded them
//    PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
//    [photoACL setPublicReadAccess:YES];
//    photo.ACL = photoACL;
//    
//    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
//    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
//    }];
//
//    // save
//    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"Photo uploaded");
//            
////            [[PAPCache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
//          
//            // userInfo might contain any caption which might have been posted by the uploader
////            if (userInfo) {
////                NSString *commentText = [userInfo objectForKey:kPhotoComment];
////                if (commentText && commentText.length != 0) {
////                    // create and save photo caption
////                  // location too
//////                    PFObject *comment = [PFObject objectWithClassName:kCommentClassKey];
//////                    [comment setObject:photo forKey:kCommentForPostKey];
//////                    [comment setObject:[PFUser currentUser] forKey:kCommentFromUserKey];
//////                    [comment setObject:[PFUser currentUser] forKey:kCommentToUserKey];
//////                    [comment setObject:commentText forKey:kCommentTextKey];
////                  
//////                    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
//////                    [ACL setPublicReadAccess:YES];
//////                    comment.ACL = ACL;
////                  
////                  [photo saveEventually];
//////                    [[PAPCache sharedCache] incrementCommentCountForPhoto:photo];
////                }
////            }
////
////            [[NSNotificationCenter defaultCenter] postNotificationName:PAPTabBarControllerDidFinishEditingPhotoNotification object:photo];
//        } else {
//            NSLog(@"Photo failed to save: %@", error);
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
//            [alert show];
//        }
//        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
//    }];
  
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelPost:(id)sender {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark UITextView nofitication methods

- (void)textInputChanged:(NSNotification *)note {
  postButton.enabled = [self findEmptyViews] == nil;
}

#pragma mark Private helper methods

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
