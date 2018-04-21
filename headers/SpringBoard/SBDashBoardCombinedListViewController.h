#import <SpringBoard/SBDashBoardNotificationDispatcher.h>
#import <UserNotificationsKit/NCNotificationListViewControllerDestinationDelegate-Protocol.h>

@interface  SBDashBoardCombinedListViewController : UIViewController <NCNotificationListViewControllerDestinationDelegate>
@property (assign,nonatomic) SBDashBoardNotificationDispatcher *dispatcher; 
-(void)notificationListViewController:(id)arg1 requestsClearingNotificationRequestsFromDate:(id)arg2 toDate:(id)arg3 inSections:(id)arg4;
-(void)notificationListViewController:(id)arg1 requestsClearingNotificationRequestsInSections:(id)arg2;
-(void)notificationListViewController:(id)arg1 requestsClearingNotificationRequests:(NSSet *)requests;
@end