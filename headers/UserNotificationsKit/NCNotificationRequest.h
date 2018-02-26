#import "NCNotificationContent.h"

@interface NCNotificationRequest : NSObject
@property (nonatomic,copy,readonly) NSString *sectionIdentifier;
@property (nonatomic,readonly) NCNotificationContent *content;
@property (nonatomic,readonly) NSDate *timestamp;
@property (nonatomic,copy,readonly) NSString *notificationIdentifier; 
@end
