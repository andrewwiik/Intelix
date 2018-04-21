#import "_NCNotificationViewControllerView.h"
#import <UserNotificationsKit/NCNotificationRequest.h>

@interface NCNotificationViewController : UIViewController
@property (nonatomic,retain) NCNotificationRequest * notificationRequest;   
@property (nonatomic, retain) _NCNotificationViewControllerView *view;
- (BOOL)dismissPresentedViewControllerAndClearNotification:(BOOL)arg1 animated:(BOOL)animated;
- (BOOL)dismissPresentedViewControllerAndClearNotification:(BOOL)arg1 animated:(BOOL)animated completion:(void (^)())completionBlock;
- (UIViewController *)_presentedLongLookViewController;
@end