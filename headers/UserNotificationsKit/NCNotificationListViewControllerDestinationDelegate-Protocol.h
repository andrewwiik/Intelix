@protocol NCNotificationListViewControllerDestinationDelegate <NSObject>
@optional
-(void)notificationListViewController:(id)arg1 requestsClearingNotificationRequestsFromDate:(id)arg2 toDate:(id)arg3 inSections:(id)arg4;
-(void)notificationListViewController:(id)arg1 requestsClearingNotificationRequestsInSections:(id)arg2;
@required
-(void)notificationListViewController:(id)arg1 requestsClearingNotificationRequests:(id)arg2;
@end