#import "NCNotificationChronologicalList.h"
#import <UserNotificationsKit/NCNotificationRequest.h>
#import "ITXNCGroupFooterView.h"
#import <UserNotificationsUIKit/NCNotificationCombinedListViewController.h>

@interface NCNotificationCombinedListViewController (Intelix)
- (NCNotificationChronologicalList *)notificationSectionList;
- (void)sectionFooterView:(ITXNCGroupFooterView *)footerView didReceiveToggleExpansionActionForSectionIdentifier:(NSString *)sectionIdentifier;
- (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didInsertNotificationRequests:(NSArray<NCNotificationRequest *> *)requests atIndexPaths:(NSArray<NSIndexPath *> *)paths reloadIndexPaths:(NSArray<NSIndexPath *> *)reloadPaths;
- (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didRemoveNotificationRequests:(NSArray<NCNotificationRequest *> *)requests atIndexPaths:(NSArray<NSIndexPath *> *)paths reloadIndexPaths:(NSArray<NSIndexPath *> *)reloadPaths;
@end