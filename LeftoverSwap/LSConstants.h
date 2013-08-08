//
//  LSConstants.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/24/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#pragma mark - PFObject User Class
// Field keys
extern NSString *const kUserDisplayNameKey;
extern NSString *const kUserEmailKey;
extern NSString *const kUserPrivateChannelKey;

#pragma mark - PFObject Post Class
// Class key
extern NSString *const kPostClassKey;

// Field keys
extern NSString *const kPostImageKey;
extern NSString *const kPostThumbnailKey;
extern NSString *const kPostUserKey;
extern NSString *const kPostTitleKey;
extern NSString *const kPostDescriptionKey;
extern NSString *const kPostLocationKey;

#pragma mark - PFObject Comment Class
// Class key
extern NSString *const kCommentClassKey;

// Field keys
extern NSString *const kCommentFromUserKey;
extern NSString *const kCommentToUserKey;
extern NSString *const kCommentForPostKey;
extern NSString *const kCommentTextKey;

#pragma mark - NSNotitication keys

extern NSString * const kLSPostCreatedNotification;
