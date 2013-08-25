//
//  PAWPost.m
//  Anywall
//
//  Created by Christopher Bowns on 2/8/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "LSPost.h"

#import "LSAppDelegate.h"
#import "LSConstants.h"
#import "LSPostDetailViewController.h"

NSString *const kCantViewPostTitle = @"Can't view Post! Get closer";

@interface LSPost ()

// Redefine these properties to make them read/write for internal class accesses and mutations.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geopoint;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;

@end

@implementation LSPost

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle {
	self = [super init];
	if (self) {
		self.coordinate = aCoordinate;
		self.title = aTitle;
		self.subtitle = aSubtitle;
		self.animatesDrop = NO;
    self.pinColor = MKPinAnnotationColorGreen;
	}
	return self;
}

- (id)initWithPFObject:(PFObject *)anObject {
	self.object = anObject;
	self.geopoint = [anObject objectForKey:kPostLocationKey];
	self.user = [anObject objectForKey:kPostUserKey];

	[anObject fetchIfNeeded]; 
	CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
	NSString *aTitle = [anObject objectForKey:kPostTitleKey];
	NSString *aSubtitle = [anObject objectForKey:kPostDescriptionKey];

	return [self initWithCoordinate:aCoordinate andTitle:aTitle andSubtitle:aSubtitle];
}

- (BOOL)equalToPost:(LSPost *)aPost {
	if (aPost == nil) {
		return NO;
	}

	if (aPost.object && self.object) {
		// We have a PFObject inside the PAWPost, use that instead.
		if ([aPost.object.objectId compare:self.object.objectId] != NSOrderedSame) {
			return NO;
		}
		return YES;
	} else {
		// Fallback code:

		if ([aPost.title compare:self.title] != NSOrderedSame ||
			[aPost.subtitle compare:self.subtitle] != NSOrderedSame ||
			aPost.coordinate.latitude != self.coordinate.latitude ||
			aPost.coordinate.longitude != self.coordinate.longitude ) {
			return NO;
		}

		return YES;
	}
}

-(PFFile *)thumbnail {
  return [self.object objectForKey:kPostThumbnailKey];
}

- (void)setupAnnotationView:(MKPinAnnotationView *)pinView
{
  pinView.pinColor = [self pinColor];
  pinView.animatesDrop = [self animatesDrop];
  pinView.canShowCallout = YES;
  
  PFImageView *thumbnailView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
  thumbnailView.file = self.thumbnail;
  pinView.leftCalloutAccessoryView = thumbnailView;
  [thumbnailView loadInBackground];
  
  // note: when the detail disclosure button is tapped, we respond to it via:
  //       calloutAccessoryControlTapped delegate method
  UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
  pinView.rightCalloutAccessoryView = rightButton;
}

- (UIViewController *)viewControllerForPost
{
  return [[LSPostDetailViewController alloc] initWithNibName:nil bundle:nil post:self.object];
}

@end
