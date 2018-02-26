#import <UserNotificationsKit/NCNotificationRequest.h>

@interface NCNotificationPriorityList : NSObject
@property (nonatomic,retain) NSMutableOrderedSet* requests;           //@synthesize requests=_requests - In the implementation block
@property (nonatomic,readonly) NSUInteger count; 
-(id)requests;
-(id)requestAtIndex:(NSUInteger)index;
-(void)setRequests:(NSMutableOrderedSet *)requests;
-(id)init;
-(NSUInteger)count;
-(NSArray *)allNotificationRequests;
-(BOOL)containsNotificationRequestMatchingRequest:(NCNotificationRequest *)request;
-(NSUInteger)removeNotificationRequest:(NCNotificationRequest *)request;
-(NSUInteger)insertionIndexForNotificationRequest:(NCNotificationRequest *)request;
-(NSUInteger)insertNotificationRequest:(NCNotificationRequest *)request;
-(NSUInteger)indexOfNotificationRequestMatchingRequest:(NCNotificationRequest *)request;
-(NSUInteger)modifyNotificationRequest:(NCNotificationRequest *)request;
-(id)clearNonPersistentRequests;
-(id)clearRequestsPassingTest:(/*^block*/ id)arg1 ;
-(NSUInteger)_insertionIndexForNotificationRequest:(NCNotificationRequest *)request;
-(NSUInteger)_indexOfRequestMatchingNotificationRequest:(NCNotificationRequest *)request;
-(id)_clearRequestsWithPersistence:(NSUInteger)arg1 ;
-(id)_identifierForNotificationRequest:(NCNotificationRequest *)request;
-(id)clearAllRequests;
@end