//
//  PAPEditPhotoViewController.h
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//

@interface LSEditPhotoViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)aImage;

@property (nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UITextField *titleTextField;
@property (nonatomic) IBOutlet UITextView *descriptionTextView;


@end
