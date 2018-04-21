#import "NCNotificationChronologicalList.h"
#import <UserNotificationsKit/NCNotificationRequest.h>
#import "NCNotificationPriorityList.h"
#import <UserNotificationsKit/NCNotificationListViewControllerDestinationDelegate-Protocol.h>
#import <SpringBoard/SBDashBoardCombinedListViewController.h>
#import <UserNotificationsUIKit/NCNotificationViewController.h>

@interface NCNotificationCombinedListViewController : UICollectionViewController
@property (nonatomic,retain) SBDashBoardCombinedListViewController *destinationDelegate; 
@property (assign,getter=isShowingNotificationsHistory,nonatomic) BOOL showingNotificationsHistory; 
@property (nonatomic,retain) NCNotificationPriorityList *notificationPriorityList;
- (BOOL)_isNotificationRequestForLockScreenNotificationDestination:(NCNotificationRequest *)request;
@property (nonatomic, readonly) NCNotificationChronologicalList *sectionList;
@property (assign,nonatomic) BOOL notificationHistorySectionNeedsReload;

- (NSIndexPath *)_adjustedSectionIndexPathForCollectionViewOperation:(NSIndexPath *)originalPath;
- (NSIndexPath *)_adjustedSectionIndexPathForListOperation:(NSIndexPath *)originalPath;

- (NSUInteger)_adjustedSectionIndexForListOperation:(NSUInteger)originalSection; // - 1
- (NSUInteger)_adjustedSectionIndexForCollectionViewOperation:(NSUInteger)originalSection; // + 1

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (void)_performCollectionViewOperationBlockIfNecessary:(void (^)())block;

- (void)_updateSupplementaryView:(UIView *)view layoutAttributes:(UICollectionViewLayoutAttributes *)attributes forRevealPercentage:(CGFloat)percentage atIndexPath:(NSIndexPath *)indexPath;

- (void)forceNotificationHistoryRevealed:(BOOL)revealed animated:(BOOL)animated;
- (void)_revealNotificationsHistory;

- (BOOL)hasContent;
- (void)notifyContentObservers;

- (BOOL)modifyNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2;

- (void)_createRequestOperationAnimationCoordinatorForInitialContentPresentation:(BOOL)initial;
- (void)_updateRaiseToListenRequest;

- (NCNotificationRequest *)notificationRequestInLongLook;
- (NCNotificationRequest *)notificationRequestPossiblyInLongLook;

@property (assign,nonatomic) CGFloat prioritySectionLowestPosition;
-(void)_updatePrioritySectionLowestPosition;

- (NSMutableArray<NSIndexPath *> *)_filteredIndexPathsForAnimationFromIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (BOOL)isShowingNotificationsHistory;

-(void)notificationSectionList:(id)list didInsertSectionAtIndex:(NSUInteger)section;
-(void)notificationSectionList:(id)list didRemoveSectionAtIndex:(NSUInteger)section;

- (void)_setShowingNotificationsHistory:(BOOL)showing animated:(BOOL)animated;
- (void)_reloadNotificationHistorySectionIfNecessary;

- (void)_resetNotificationsHistory;

- (void)_removeCachedSizesForNotificationRequest:(NCNotificationRequest *)request;

- (NCNotificationViewController *)viewControllerPresentingLongLook;
@end