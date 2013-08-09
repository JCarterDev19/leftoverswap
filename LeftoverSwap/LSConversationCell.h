//
//  PAPBaseTextCell.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/15/12.
//

#import <Parse/Parse.h>

@class LSConversationCell;

/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol LSConversationCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(LSConversationCell*)cellView didTapUserButton:(PFUser *)aUser;

@end

@interface LSConversationCell : UITableViewCell

@property (nonatomic, weak) id<LSConversationCellDelegate> delegate;

/*! The user represented in the cell */
@property (nonatomic) PFUser *user;

/*! The cell's views. These shouldn't be modified but need to be exposed for the subclass */
@property (nonatomic) UIView *mainView;
@property (nonatomic) UIButton *nameButton;
@property (nonatomic) UILabel *contentLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UIImageView *separatorImage;

@property (nonatomic) CGFloat horizontalCellInsetWidth;

/*! Setters for the cell's content */
- (void)setContentText:(NSString *)contentString;
- (void)setDate:(NSDate *)date;

- (void)setHorizontalCellInsetWidth:(CGFloat)insetWidth;
- (void)hideSeparator:(BOOL)hide;

/*! Static Helper methods */
+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content;
+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content cellInsetWidth:(CGFloat)cellInset;
+ (NSString *)padString:(NSString *)string withFont:(UIFont *)font toWidth:(CGFloat)width;

@end

/*! Layout constants */
#define vertBorderSpacing 8.0f
#define vertElemSpacing 0.0f

#define horiBorderSpacing 8.0f
#define horiBorderSpacingBottom 9.0f
#define horiElemSpacing 5.0f

#define vertTextBorderSpacing 10.0f

#define avatarX horiBorderSpacing
#define avatarY vertBorderSpacing
#define avatarDim 33.0f

#define nameX avatarX+avatarDim+horiElemSpacing
#define nameY vertTextBorderSpacing
#define nameMaxWidth 200.0f

#define timeX avatarX+avatarDim+horiElemSpacing

