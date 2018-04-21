#import <UserNotificationsKit/NCNotificationRequest.h>

@interface NCNotificationDispatcher : NSObject
-(void)destination:(id)arg1 requestsClearingNotificationRequests:(NSSet *)requests fromDestinations:(NSSet *)destinations;
-(void)postNotificationWithRequest:(NCNotificationRequest *)request;
-(void)modifyNotificationWithRequest:(NCNotificationRequest *)request;
-(void)withdrawNotificationWithRequest:(NCNotificationRequest *)request;
-(void)updateNotificationSectionSettings:(id)arg1 ;
-(void)removeNotificationSectionWithIdentifier:(id)arg1 ;

- (NSHashTable *)sourceDelegates;
- (void)destination:(id)arg1 requestsClearingNotificationRequests:(NSSet *)requests;
@end