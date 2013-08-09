//
//  PAPActivityFeedViewController.m
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/9/12.
//

#import "LSConversationViewController.h"
#import "LSConversationCell.h"
#import "LSConstants.h"
//#import "MBProgressHUD.h"

@interface LSConversationViewController ()

@property (nonatomic) NSDate *lastRefresh;
@property (nonatomic) UIView *blankTimelineView;

@end

@implementation LSConversationViewController

@synthesize lastRefresh;
@synthesize blankTimelineView;

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // The className to query on
    self.parseClassName = kConversationClassKey;
    
    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = NO;
    
    // Whether the built-in pagination is enabled
    self.paginationEnabled = NO;
    
    // The number of objects to show per page
    self.objectsPerPage = 15;
  }
  return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [super viewDidLoad];
    
//    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
//    [texturedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLeather.png"]]];
//    self.tableView.backgroundView = texturedBackgroundView;
//
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];

    // Add Settings button
//    self.navigationItem.rightBarButtonItem = [[PAPSettingsButtonItem alloc] initWithTarget:self action:@selector(settingsButtonAction:)];
//  
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveRemoteNotification:) name:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil];
  
//    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:[UIImage imageNamed:@"ActivityFeedBlank.png"] forState:UIControlStateNormal];
//    [button setFrame:CGRectMake(24.0f, 113.0f, 271.0f, 140.0f)];
//    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.blankTimelineView addSubview:button];

//    lastRefresh = [[NSUserDefaults standardUserDefaults] objectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        NSString *activityString = [LSConversationViewController stringForActivityType:(NSString*)[object objectForKey:kConversationTypeKey]];
        PFUser *user = (PFUser*)[object objectForKey:kConversationFromUserKey];
        NSString *nameString = @"";

        if (user) {
            nameString = [user objectForKey:kUserDisplayNameKey];
        }
        
        return [LSConversationCell heightForCellWithName:nameString contentString:activityString];
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.row < self.objects.count) {
//    PFObject *activity = [self.objects objectAtIndex:indexPath.row];
    //        if ([activity objectForKey:kPAPActivityPhotoKey]) {
    //            PAPPhotoDetailsViewController *detailViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:[activity objectForKey:kPAPActivityPhotoKey]];
    //            [self.navigationController pushViewController:detailViewController animated:YES];
//    if ([activity objectForKey:kCon]) {
//      PAPAccountViewController *detailViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
//      [detailViewController setUser:[activity objectForKey:kPAPActivityFromUserKey]];
//      [self.navigationController pushViewController:detailViewController animated:YES];
//    }
  } else if (self.paginationEnabled) {
    // load more
    [self loadNextPage];
  }
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }

    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kConversationToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kConversationFromUserKey notEqualTo:[PFUser currentUser]];
    [query whereKeyExists:kConversationFromUserKey];
    [query includeKey:kConversationFromUserKey];
//    [query includeKey:kPAPActivityPhotoKey];
    [query orderByDescending:@"createdAt"];

    [query setCachePolicy:kPFCachePolicyNetworkOnly];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        NSLog(@"Loading from cache");
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    

    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
//    
//    lastRefresh = [NSDate date];
//    [[NSUserDefaults standardUserDefaults] setObject:lastRefresh forKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];

//    [MBProgressHUD hideHUDForView:self.view animated:YES];
  
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
        self.tableView.scrollEnabled = NO;
        self.navigationController.tabBarItem.badgeValue = nil;

        if (!self.blankTimelineView.superview) {
            self.blankTimelineView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankTimelineView;
            
            [UIView animateWithDuration:0.200f animations:^{
                self.blankTimelineView.alpha = 1.0f;
            }];
        }
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
        
        NSUInteger unreadCount = 0;
        for (PFObject *activity in self.objects) {
//            if ([lastRefresh compare:[activity createdAt]] == NSOrderedAscending && ![[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeJoined]) {
//                unreadCount++;
//            }
        }
        
        if (unreadCount > 0) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadCount];
        } else {
            self.navigationController.tabBarItem.badgeValue = nil;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
  static NSString *const cellIdentifier = @"LSConversationCell";
  
  LSConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[LSConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setDelegate:self];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
  }
  
//  [cell setActivity:object];
  
//  [cell setIsNew:YES];
  //    if ([lastRefresh compare:[object createdAt]] == NSOrderedAscending) {
  //        [cell setIsNew:YES];
  //    } else {
  //        [cell setIsNew:NO];
  //    }
  
  [cell hideSeparator:(indexPath.row == self.objects.count - 1)];
  
  return cell;
}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
//    
//    PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
//    if (!cell) {
//        cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.hideSeparatorBottom = YES;
//        cell.mainView.backgroundColor = [UIColor clearColor];
//   }
//    return cell;
//}


#pragma mark - LSConversationCellDelegate Methods

- (void)cell:(LSConversationCell *)cellView didTapActivityButton:(PFObject *)activity {
    // Get image associated with the activity
//    PFObject *photo = [activity objectForKey:kPAPActivityPhotoKey];
//    
//    // Push single photo view controller
//    PAPPhotoDetailsViewController *photoViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:photo];
//    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)cell:(LSConversationCell *)cellView didTapUserButton:(PFUser *)user {
    // Push account view controller
//    PAPAccountViewController *accountViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
//    [accountViewController setUser:user];
//    [self.navigationController pushViewController:accountViewController animated:YES];
}


#pragma mark - PAPActivityFeedViewController

+ (NSString *)stringForActivityType:(NSString *)activityType {
    if ([activityType isEqualToString:kConversationTypeMessageKey]) {
        return @"Message";
    } else if ([activityType isEqualToString:kConversationTypeTopicKey]) {
        return @"Topic";
    } else {
        return nil;
    }
}

@end
