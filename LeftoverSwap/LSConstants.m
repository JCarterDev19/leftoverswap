//
//  LSConstants.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/24/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSConstants.h"

#pragma mark - PFObject User Class
// Field keys
NSString *const kUserDisplayNameKey = @"displayName";
NSString *const kUserEmailKey = @"email";
NSString *const kUserPrivateChannelKey = @"channel";

#pragma mark - PFObject Post Class
// Class key
NSString *const kPostClassKey = @"Post";

// Field keys
NSString *const kPostImageKey = @"image";
NSString *const kPostThumbnailKey = @"thumbnail";
NSString *const kPostUserKey = @"user";
NSString *const kPostTitleKey = @"title";
NSString *const kPostDescriptionKey = @"description";
NSString *const kPostLocationKey = @"location";

#pragma mark - PFObject Comment Class
// Class key
NSString *const kConversationClassKey = @"Conversation";
NSString *const kConversationTypeKey = @"type";

// Type key
NSString *const kConversationTypeTopicKey = @"topic";
NSString *const kConversationTypeMessageKey = @"message";

// Field keys
NSString *const kConversationFromUserKey = @"fromUser";
NSString *const kConversationToUserKey = @"toUser";
NSString *const kConversationTopicKey = @"topic";
NSString *const kConversationMessageKey = @"message";

NSString *const kLSPostCreatedNotification = @"kPostCreatedNotification";
