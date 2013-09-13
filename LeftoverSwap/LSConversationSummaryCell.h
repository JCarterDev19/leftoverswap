//
//  LSConversationSummaryCell.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/11/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSConversationSummaryCell, PFObject;

@protocol LSConversationSummaryCellDelegate <NSObject>
@optional

- (void)cell:(LSConversationSummaryCell*)cellView didTapConversation:(PFObject*)conversation;

@end

@interface LSConversationSummaryCell : UITableViewCell

+ (NSInteger)heightForCell;

@property (nonatomic) PFObject *conversation;
@property (nonatomic, weak) id<LSConversationSummaryCellDelegate> delegate;

@end
