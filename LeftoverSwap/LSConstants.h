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

#pragma mark - PFObject Conversation Class
// Class key
extern NSString *const kConversationClassKey;
extern NSString *const kConversationTypeKey;

// Type key
extern NSString *const kConversationTypeTopicKey;
extern NSString *const kConversationTypeMessageKey;

// Field keys
extern NSString *const kConversationFromUserKey;
extern NSString *const kConversationToUserKey;
extern NSString *const kConversationTopicPostKey;
extern NSString *const kConversationMessageKey;

#pragma mark - NSNotitication keys

// NSNotification notifications
extern NSString * const kLSFilterDistanceChangeNotification;
extern NSString * const kLSFilterDistanceKey;

extern NSString * const kLSLocationChangeNotification;
extern NSString * const kLSLocationKey;

extern NSString * const kLSPostCreatedNotification;
extern NSString * const kLSPostKey;

#pragma mark - PFInstallation keys

extern NSString * const kLSInstallationChannelsKey;