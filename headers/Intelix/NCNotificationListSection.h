#import <UserNotificationsUIKit/NCNotificationListSection.h>

@interface NCNotificationListSection (Intelix)
@property (nonatomic, retain) NSString *otherSectionIdentifier;
@property (nonatomic, retain) UIImage *iconImage; 
- (NSInteger)count;
@end