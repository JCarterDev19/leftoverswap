//
//  PAPEditPhotoViewController.h
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//

@class LSPaddedTextField;

@class LSPostPhotoViewController;

@protocol LSPostPhotoViewControllerDelegate <NSObject>

- (void)postPhotoControllerDidFinishPosting:(LSPostPhotoViewController *)post;
- (void)postPhotoControllerDidCancel:(LSPostPhotoViewController *)post;

@end

@interface LSPostPhotoViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)aImage;

@property (nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet LSPaddedTextField *titleTextField;
@property (nonatomic) IBOutlet UITextView *descriptionTextView;
@property (nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (nonatomic, weak) id<LSPostPhotoViewControllerDelegate> delegate;

- (IBAction)cancelPost:(id)sender;
- (IBAction)postPost:(id)sender;

@end
