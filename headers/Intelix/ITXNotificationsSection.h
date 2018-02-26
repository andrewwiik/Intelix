#import <UserNotificationsKit/NCNotificationRequest.h>

@interface ITXNotificationsSection : NSObject
@property (nonatomic, retain, readwrite) NSMutableArray<NCNotificationRequest *> *notifications;
@property (nonatomic, retain, readwrite) NSString *identifier;
@property (nonatomic, retain, readwrite) UIImage *icon;
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSDate *recentNotificationDate;
@property (nonatomic, assign, readwrite) BOOL isCollapsed;

- (id)init;
- (void)insertNotificationRequest:(NCNotificationRequest *)notification;
- (void)removeNotificationRequest:(NCNotificationRequest *)notification;
- (void)modifyNotificationRequest:(NCNotificationRequest *)notification;
- (NSUInteger)indexOfNotification:(NCNotificationRequest *)notification;
- (NSUInteger)count;
- (void)recomputeMostRecentDate;
- (NCNotificationRequest *)requestAtIndex:(NSUInteger)index;
- (NCNotificationRequest *)notificationAtIndex:(NSUInteger)index;
@end