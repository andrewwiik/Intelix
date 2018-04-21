#import "NCNotificationChronologicalList.h"
#import <UserNotificationsKit/NCNotificationRequest.h>
#import "ITXNCGroupFooterView.h"
#import <UserNotificationsUIKit/NCNotificationCombinedListViewController.h>
#import <UserNotificationsKit/NCNotificationDispatcher.h>

@interface NCNotificationCombinedListViewController (Intelix)
- (NCNotificationChronologicalList *)notificationSectionList;
- (void)sectionFooterView:(ITXNCGroupFooterView *)footerView didReceiveToggleExpansionActionForSectionIdentifier:(NSString *)sectionIdentifier;
- (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didInsertNotificationRequests:(NSArray<NCNotificationRequest *> *)requests atIndexPaths:(NSArray<NSIndexPath *> *)paths reloadIndexPaths:(NSArray<NSIndexPath *> *)reloadPaths;
- (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didRemoveNotificationRequests:(NSArray<NCNotificationRequest *> *)requests atIndexPaths:(NSArray<NSIndexPath *> *)paths reloadIndexPaths:(NSArray<NSIndexPath *> *)reloadPaths;

// Clear All
- (void)clearNotificationRequests:(NSArray *)requests;
- (void)clearNotificationsInSection:(NSUInteger)section;

// Check if Actually supposed to be on LS
- (BOOL)shouldBelongOnLockscreen:(NCNotificationRequest *)request;
+ (NCNotificationCombinedListViewController *)sharedController;

// Notification Source
- (NCNotificationDispatcher *)notificationDispatcher;
@end