//
//  PAWWallViewController.m
//  Anywall
//
//  Created by Christopher Bowns on 1/30/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "LSMapViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "LSConstants.h"
#import "LSAppDelegate.h"
#import "LSLocationController.h"
#import "LSPost.h"

// private methods and properties
@interface LSMapViewController ()

@property (nonatomic) LSLocationController *locationController;
@property (nonatomic) BOOL mapPinsPlaced;
@property (nonatomic) BOOL mapPannedSinceLocationUpdate;

// posts:
@property (nonatomic) NSMutableArray *allPosts;

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance;
- (void)centerMapOnCurrentLocation;

// NSNotification callbacks
- (void)distanceFilterDidChange:(NSNotification *)note;
- (void)locationDidChange:(NSNotification *)note;
- (void)postWasCreated:(NSNotification *)note;

@end

@implementation LSMapViewController

@synthesize mapView;
@synthesize allPosts;
@synthesize mapPinsPlaced;
@synthesize mapPannedSinceLocationUpdate;
@synthesize locationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {

    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"TabBarMap.png"] tag:0];

		allPosts = [[NSMutableArray alloc] initWithCapacity:10];
    
    LSAppDelegate *appDelegate = (LSAppDelegate*)[[UIApplication sharedApplication] delegate];
    locationController = appDelegate.locationController;
	}
	return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(distanceFilterDidChange:) name:kLSFilterDistanceChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kLSLocationChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postWasCreated:) name:kLSPostCreatedNotification object:nil];

	self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.332495f, -122.029095f), MKCoordinateSpanMake(0.008516f, 0.021801f));
	self.mapPannedSinceLocationUpdate = NO;

  [locationController startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
	[locationController startUpdatingLocation];
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[locationController stopUpdatingLocation];
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
	[locationController stopUpdatingLocation];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kLSFilterDistanceChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kLSLocationChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kLSPostCreatedNotification object:nil];
	
	self.mapPinsPlaced = NO; // reset this for the next time we show the map.
}

#pragma mark - NSNotificationCenter notification handlers

- (void)distanceFilterDidChange:(NSNotification *)note
{
  CLLocation *currentLocation = locationController.currentLocation;
  CLLocationAccuracy filterDistance = locationController.filterDistance;

	// If they panned the map since our last location update, don't recenter it.
	if (!self.mapPannedSinceLocationUpdate) {
		// Set the map's region centered on their location at 2x filterDistance
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, filterDistance * 2, filterDistance * 2);

		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = NO;
	} else {
		// Just zoom to the new search radius (or maybe don't even do that?)
		MKCoordinateRegion currentRegion = mapView.region;
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(currentRegion.center, filterDistance * 2, filterDistance * 2);

		BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = oldMapPannedValue;
	}
}

- (void)locationDidChange:(NSNotification *)note
{
  CLLocation *currentLocation = locationController.currentLocation;
  CLLocationAccuracy filterDistance = locationController.filterDistance;

	// If they panned the map since our last location update, don't recenter it.
	if (!self.mapPannedSinceLocationUpdate) {
		// Set the map's region centered on their new location at 2x filterDistance
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, filterDistance * 2, filterDistance * 2);

		BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = oldMapPannedValue;
	} // else do nothing.

	// Update the map with new pins:
	[self queryForAllPostsNearLocation:currentLocation withNearbyDistance:filterDistance];
}

- (void)postWasCreated:(NSNotification *)notification
{
  NSLog(@"%s", __PRETTY_FUNCTION__);

  PFObject *post = notification.userInfo[kLSPostKey];
  PFGeoPoint *geoPoint = [post objectForKey:kPostLocationKey];
  CLLocation *postLocation = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
  CLLocationAccuracy filterDistance = locationController.filterDistance;

	[self queryForAllPostsNearLocation:postLocation withNearbyDistance:filterDistance];
}

#pragma mark - MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[LSPost class]]) {
    static NSString *pinIdentifier = @"CustomPinAnnotation";    

		// Try to dequeue an existing pin view first.
		MKPinAnnotationView *pinView = (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];

		if (!pinView) {
			// If an existing pin view was not available, create one.
			pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
		} else {
			pinView.annotation = annotation;
		}
    [(LSPost*)annotation setupAnnotationView:pinView];

		return pinView;
	}

	return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
  if (![[view annotation] isKindOfClass:[LSPost class]])
    return;
  
  [self presentViewController:[(LSPost*)view.annotation viewControllerForPost] animated:YES completion:nil];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	id<MKAnnotation> annotation = view.annotation;
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    [self centerMapOnCurrentLocation];
	}
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	self.mapPannedSinceLocationUpdate = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  // FIXME: this does way too many queries when scrolling
  CLLocationCoordinate2D coordinates = self.mapView.centerCoordinate;
  CLLocation *mapLocation = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
  
	[self queryForAllPostsNearLocation:mapLocation withNearbyDistance:self.locationController.filterDistance];
}

#pragma mark - Fetch map pins

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance
{
  static NSUInteger const kPostLimit = 20;

	PFQuery *query = [PFQuery queryWithClassName:kPostClassKey];

	if (currentLocation == nil) {
		NSLog(@"%s got a nil location!", __PRETTY_FUNCTION__);
	}

	// If no objects are loaded in memory, we look to the cache first to fill the table
	// and then subsequently do a query against the network.
	if ([self.allPosts count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}

	// Query for posts sort of kind of near our current location.
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:kPostLocationKey nearGeoPoint:point withinKilometers:100];
	[query includeKey:kPostUserKey];
	query.limit = kPostLimit;

	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"error in geo query!"); // todo why is this ever happening?
		} else {
			// We need to make new post objects from objects,
			// and update allPosts and the map to reflect this new array.
			// But we don't want to remove all annotations from the mapview blindly,
			// so let's do some work to figure out what's new and what needs removing.

			// 1. Find genuinely new posts:
			NSMutableArray *newPosts = [[NSMutableArray alloc] initWithCapacity:kPostLimit];
			// (Cache the objects we make for the search in step 2:)
			NSMutableArray *allNewPosts = [[NSMutableArray alloc] initWithCapacity:kPostLimit];
			for (PFObject *object in objects) {
				LSPost *newPost = [[LSPost alloc] initWithPFObject:object];
				[allNewPosts addObject:newPost];
				BOOL found = NO;
				for (LSPost *currentPost in allPosts) {
					if ([newPost equalToPost:currentPost]) {
						found = YES;
					}
				}
				if (!found) {
					[newPosts addObject:newPost];
				}
			}
			// newPosts now contains our new objects.

			// 2. Find posts in allPosts that didn't make the cut.
			NSMutableArray *postsToRemove = [[NSMutableArray alloc] initWithCapacity:kPostLimit];
			for (LSPost *currentPost in allPosts) {
				BOOL found = NO;
				// Use our object cache from the first loop to save some work.
				for (LSPost *allNewPost in allNewPosts) {
					if ([currentPost equalToPost:allNewPost]) {
						found = YES;
					}
				}
				if (!found) {
					[postsToRemove addObject:currentPost];
				}
			}
			// postsToRemove has objects that didn't come in with our new results.

			// 3. Configure our new posts; these are about to go onto the map.
			for (LSPost *newPost in newPosts) {
				CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:newPost.coordinate.latitude longitude:newPost.coordinate.longitude];
				// if this post is outside the filter distance, don't show the regular callout.
				CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
				[newPost setTitleAndSubtitleOutsideDistance:( distanceFromCurrent > nearbyDistance ? YES : NO )];
				// Animate all pins after the initial load:
				newPost.animatesDrop = mapPinsPlaced;
			}

			// At this point, newAllPosts contains a new list of post objects.
			// We should add everything in newPosts to the map, remove everything in postsToRemove,
			// and add newPosts to allPosts.
			[mapView removeAnnotations:postsToRemove];
			[mapView addAnnotations:newPosts];
			[allPosts addObjectsFromArray:newPosts];
			[allPosts removeObjectsInArray:postsToRemove];

			self.mapPinsPlaced = YES;
		}
	}];
}

#pragma mark - Center on current location

- (void)centerMapOnCurrentLocation
{
  CLLocation *currentLocation = locationController.currentLocation;
  CLLocationAccuracy filterDistance = locationController.filterDistance;
  
  // Center the map on the user's current location:
  MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, filterDistance * 2, filterDistance * 2);
  
  [self.mapView setRegion:newRegion animated:YES];
  self.mapPannedSinceLocationUpdate = NO;
}

@end
