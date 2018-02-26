@class NCNotificationCombinedListViewController;

#import "NCNotificationListSection.h"
#import <UserNotificationsKit/NCNotificationRequest.h>

@interface NCNotificationChronologicalList : NSObject
@property (nonatomic,retain) NSMutableArray<NCNotificationListSection *> *sections;
- (NSMutableArray<NCNotificationListSection *> *)sections;
- (NSUInteger)rowCountForSectionIndex:(NSUInteger)index;
@property (nonatomic, retain) NCNotificationCombinedListViewController *delegate; 
- (id)_existingSectionForNotificationRequest:(NCNotificationRequest *)request;
- (NCNotificationRequest *)notificationRequestAtIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)sectionCount;
- (BOOL)containsNotificationRequest:(NCNotificationRequest *)request;
- (NSIndexPath *)removeNotificationRequest:(NCNotificationRequest *)request;
- (NSString *)titleForSectionIndex:(NSUInteger)index;
- (NSString *)identifierForSectionIndex:(NSUInteger)index;
@end