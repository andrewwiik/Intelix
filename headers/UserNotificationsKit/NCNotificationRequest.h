#import "NCNotificationContent.h"
#import "NCNotificationOptions.h"

@interface NCNotificationRequest : NSObject
@property (nonatomic,copy,readonly) NSString *sectionIdentifier;
@property (nonatomic,readonly) NCNotificationContent *content;
@property (nonatomic, readonly) NCNotificationOptions *options;
@property (nonatomic,readonly) NSDate *timestamp;
@property (nonatomic,copy,readonly) NSString *notificationIdentifier; 
@property (nonatomic,copy,readonly) NSSet *requestDestinations;
@end
