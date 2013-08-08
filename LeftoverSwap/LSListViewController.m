//
//  LSListViewController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/24/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "LSListViewController.h"
#import "LSEditPhotoViewController.h"
#import "LSConstants.h"
#import "LSListingCell.h"
#import "LSLoadMoreCell.h"


@interface LSListViewController ()
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;

- (void)startCameraController;

@end

@implementation LSListViewController

@synthesize navController;
@synthesize reusableSectionHeaderViews;
@synthesize shouldReloadOnAppear;
@synthesize outstandingSectionHeaderQueries;

#pragma mark - Init

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {

    self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];

    // The className to query on
    self.parseClassName = kPostClassKey;
    
    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = YES;
    
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
    
    // The number of objects to show per page
    self.objectsPerPage = 20;
    
    // Improve scrolling performance by reusing UITableView section headers
    self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
    
    self.shouldReloadOnAppear = NO;
  }
  return self;
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; // PFQueryTableViewController reads this in viewDidLoad -- would prefer to throw this in init, but didn't work
  
//  [super viewDidLoad];
  
  self.navController = [[UINavigationController alloc] init];

  [self.navigationItem setHidesBackButton:YES];

  UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:nil];
  self.navigationItem.leftBarButtonItem = filterButton;

  UIBarButtonItem *pictureButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:nil];
  pictureButton.target = self;
  pictureButton.action = @selector(startCameraController);
  self.navigationItem.rightBarButtonItem = pictureButton;

//  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
//  
//  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//  [backButton setFrame:CGRectMake(0.0f, 0.0f, 52.0f, 32.0f)];
//  [backButton setTitle:@"Back" forState:UIControlStateNormal];
//  [backButton setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
//  [[backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]];
//  [backButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f)];
//  [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
////  [backButton setBackgroundImage:[UIImage imageNamed:@"ButtonBack.png"] forState:UIControlStateNormal];
////  [backButton setBackgroundImage:[UIImage imageNamed:@"ButtonBackSelected.png"] forState:UIControlStateHighlighted];
//  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

//  UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
//  texturedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLeather.png"]];
//  self.tableView.backgroundView = texturedBackgroundView;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (self.shouldReloadOnAppear) {
    self.shouldReloadOnAppear = NO;
    [self loadObjects];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger sections = self.objects.count;
  if (self.paginationEnabled && sections != 0)
    sections++;
  return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

#pragma mark - UITableViewDelegate
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == self.objects.count) {
    // Load More section
    return nil;
  }
  
  PAPPhotoHeaderView *headerView = [self dequeueReusableSectionHeaderView];
  
  if (!headerView) {
    headerView = [[PAPPhotoHeaderView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:PAPPhotoHeaderButtonsDefault];
    headerView.delegate = self;
    [self.reusableSectionHeaderViews addObject:headerView];
  }
  
  PFObject *photo = [self.objects objectAtIndex:section];
  [headerView setPhoto:photo];
  headerView.tag = section;
  [headerView.likeButton setTag:section];
  
  NSDictionary *attributesForPhoto = [[PAPCache sharedCache] attributesForPhoto:photo];
  
  if (attributesForPhoto) {
    [headerView setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:photo]];
    [headerView.likeButton setTitle:[[[PAPCache sharedCache] likeCountForPhoto:photo] description] forState:UIControlStateNormal];
    [headerView.commentButton setTitle:[[[PAPCache sharedCache] commentCountForPhoto:photo] description] forState:UIControlStateNormal];
    
    if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
      [UIView animateWithDuration:0.200f animations:^{
        headerView.likeButton.alpha = 1.0f;
        headerView.commentButton.alpha = 1.0f;
      }];
    }
  } else {
    headerView.likeButton.alpha = 0.0f;
    headerView.commentButton.alpha = 0.0f;
    
    @synchronized(self) {
      // check if we can update the cache
      NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:[NSNumber numberWithInt:section]];
      if (!outstandingSectionHeaderQueryStatus) {
        PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
          @synchronized(self) {
            [self.outstandingSectionHeaderQueries removeObjectForKey:[NSNumber numberWithInt:section]];
            
            if (error) {
              return;
            }
            
            NSMutableArray *likers = [NSMutableArray array];
            NSMutableArray *commenters = [NSMutableArray array];
            
            BOOL isLikedByCurrentUser = NO;
            
            for (PFObject *activity in objects) {
              if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike] && [activity objectForKey:kPAPActivityFromUserKey]) {
                [likers addObject:[activity objectForKey:kPAPActivityFromUserKey]];
              } else if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeComment] && [activity objectForKey:kPAPActivityFromUserKey]) {
                [commenters addObject:[activity objectForKey:kPAPActivityFromUserKey]];
              }
              
              if ([[[activity objectForKey:kPAPActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike]) {
                  isLikedByCurrentUser = YES;
                }
              }
            }
            
            [[PAPCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
            
            if (headerView.tag != section) {
              return;
            }
            
            [headerView setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:photo]];
            [headerView.likeButton setTitle:[[[PAPCache sharedCache] likeCountForPhoto:photo] description] forState:UIControlStateNormal];
            [headerView.commentButton setTitle:[[[PAPCache sharedCache] commentCountForPhoto:photo] description] forState:UIControlStateNormal];
            
            if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
              [UIView animateWithDuration:0.200f animations:^{
                headerView.likeButton.alpha = 1.0f;
                headerView.commentButton.alpha = 1.0f;
              }];
            }
          }
        }];
      }
    }
  }
  
  return headerView;
}
 */
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == self.objects.count) {
    return 0.0f;
  }
  return 44.0f;
}*/

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 16.0f)];
  return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if (section == self.objects.count) {
    return 0.0f;
  }
  return 16.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section >= self.objects.count) {
    // Load More Section
    return 44.0f;
  }
  
  return 280.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.section == self.objects.count && self.paginationEnabled) {
    // Load More Cell
    [self loadNextPage];
  }
}


#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
//  if (![PFUser currentUser]) {
//    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//    [query setLimit:0];
//    return query;
//  }

  PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

//  PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kPAPActivityClassKey];
//  [followingActivitiesQuery whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
//  [followingActivitiesQuery whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
//  followingActivitiesQuery.limit = 1000;
//  
//  PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:self.className];
//  [photosFromFollowedUsersQuery whereKey:kPAPPhotoUserKey matchesKey:kPAPActivityToUserKey inQuery:followingActivitiesQuery];
//  [photosFromFollowedUsersQuery whereKeyExists:kPAPPhotoPictureKey];
//  
//  PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:self.className];
//  [photosFromCurrentUserQuery whereKey:kPAPPhotoUserKey equalTo:[PFUser currentUser]];
//  [photosFromCurrentUserQuery whereKeyExists:kPAPPhotoPictureKey];
//  
//  PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromFollowedUsersQuery, photosFromCurrentUserQuery, nil]];
//  [query includeKey:kPAPPhotoUserKey];
//  [query orderByDescending:@"createdAt"];
//  
//  // A pull-to-refresh should always trigger a network request.
//  [query setCachePolicy:kPFCachePolicyNetworkOnly];
//  
//  // If no objects are loaded in memory, we look to the cache first to fill the table
//  // and then subsequently do a query against the network.
//  //
//  // If there is no network connection, we will hit the cache first.
//  if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
//    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
//  }
  
  return query;
}

- (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
  // overridden, since we want to implement sections
  if (indexPath.section < self.objects.count) {
    return [self.objects objectAtIndex:indexPath.section];
  }
  
  return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
  static NSString *CellIdentifier = @"Cell";
  
  if (indexPath.section == self.objects.count) {
    // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
    UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
    return cell;
  } else {
    LSListingCell *cell = (LSListingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      cell = [[LSListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      [cell.photoButton addTarget:self action:@selector(didTapOnPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.photoButton.tag = indexPath.section;
    cell.imageView.image = [UIImage imageNamed:@"PlaceholderPhoto.png"];
    cell.imageView.file = [object objectForKey:kPostImageKey];
    
    // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
    if ([cell.imageView.file isDataAvailable]) {
      [cell.imageView loadInBackground];
    }
    
    return cell;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
  
  LSLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
  if (!cell) {
    cell = [[LSLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
    cell.selectionStyle =UITableViewCellSelectionStyleGray;
    cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
    cell.hideSeparatorBottom = YES;
    cell.mainView.backgroundColor = [UIColor clearColor];
  }
  return cell;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [self dismissModalViewControllerAnimated:NO];
  
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  if (!image) {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
  }
  
  LSEditPhotoViewController *viewController = [[LSEditPhotoViewController alloc] initWithNibName:nil bundle:nil image:image];
//  [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
  
  [self.navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
  [self.navController pushViewController:viewController animated:NO];
  
  [self presentModalViewController:self.navController animated:YES];

}

#pragma mark - ()

- (void)startCameraController {
  
  UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
  cameraUI.mediaTypes = @[(NSString*)kUTTypeImage];
  
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.showsCameraControls = YES;

    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
      cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
      cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    // Some iPods, simulator: use the Camera's photo roll
  } else {
    //    NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    NSAssert([UIImagePickerController isSourceTypeAvailable:sourceType]
             && [[UIImagePickerController availableMediaTypesForSourceType:sourceType] containsObject:(NSString *)kUTTypeImage], @"Device must support photo rolls");
    
    cameraUI.sourceType = sourceType;
    
  }

  cameraUI.allowsEditing = NO;
  cameraUI.delegate = self;
  
  [self presentModalViewController:cameraUI animated:YES];
}

@end
