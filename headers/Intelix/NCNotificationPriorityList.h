#import <UserNotificationsUIKit/NCNotificationPriorityList.h>
#import "NCNotificationChronologicalList.h"
#import <UserNotificationsKit/NCNotificationRequest.h>
#import "ITXNotificationsSection.h"
#import "NCNotificationCombinedListViewController.h"

@interface NCNotificationPriorityList (Intelix)
@property (nonatomic, retain) NSMutableArray<ITXNotificationsSection *> *sections;
@property (nonatomic, retain) NCNotificationCombinedListViewController *controller;
- (NSUInteger)sectionCount;
- (NSUInteger)rowCountForSectionIndex:(NSUInteger)section;
- (NSUInteger)actualCountInSection:(NSUInteger)section;
- (NCNotificationRequest *)notificationRequestAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForNotificationRequest:(NCNotificationRequest *)request;
- (ITXNotificationsSection *)existingSectionForRequest:(NCNotificationRequest *)request;
- (ITXNotificationsSection *)newSectionForRequest:(NCNotificationRequest *)request; 
- (NSUInteger)countOfNotificationsInSectionsBeforeSection:(NSUInteger)section;

- (NSIndexPath *)itx_insertNotificationRequest:(NCNotificationRequest *)request;
- (NSIndexPath *)itx_modifyNotificationRequest:(NCNotificationRequest *)request;
- (NSIndexPath *)itx_removeNotificationRequest:(NCNotificationRequest *)request;

- (BOOL)containsNotificationRequest:(NCNotificationRequest *)request;

- (NSString *)titleForSectionIndex:(NSUInteger)section;
- (NSString *)identifierForSectionIndex:(NSUInteger)section;

- (void)recomputeCount;

// Clear All
- (void)clearNotificationsInSection:(NSUInteger)section;
@end