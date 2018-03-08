#import <Intelix/ITXNotificationsSection.h>

@implementation ITXNotificationsSection
- (id)init {
	// HBLogInfo(@"Method #150");
	self = [super init];
	if (self) {
		_notifications = [NSMutableArray new];
		_identifier = @"";
		_title = @"Unknown";
		_recentNotificationDate = [NSDate dateWithTimeIntervalSince1970:0];
	}
	return self;
}

- (void)insertNotificationRequest:(NCNotificationRequest *)notification {
	// HBLogInfo(@"Method #151");
	if (notification) { 
		[_notifications insertObject:notification atIndex:0];
	}
	[self recomputeMostRecentDate];

}
- (void)removeNotificationRequest:(NCNotificationRequest *)notification {
	// HBLogInfo(@"Method #152");
	for (NSUInteger x = 0; x < [_notifications count]; x++) {
		if ([_notifications[x].notificationIdentifier isEqualToString:notification.notificationIdentifier]) {
			[_notifications removeObjectAtIndex:x];
			[self recomputeMostRecentDate];
			return;
		}
	}

}
- (void)modifyNotificationRequest:(NCNotificationRequest *)notification {
	// HBLogInfo(@"Method #153");
	for (NSUInteger x = 0; x < [_notifications count]; x++) {
		if ([_notifications[x].notificationIdentifier isEqualToString:notification.notificationIdentifier]) {
			[_notifications replaceObjectAtIndex:x withObject:notification];
			[self recomputeMostRecentDate];
			return;
		}
	}
}
- (NSUInteger)indexOfNotification:(NCNotificationRequest *)notification {
	// HBLogInfo(@"Method #154");
	for (NSUInteger x = 0; x < [_notifications count]; x++) {
		if ([_notifications[x].notificationIdentifier isEqualToString:notification.notificationIdentifier]) {
			return x;
		}
	}
	return NSNotFound;
}

- (NSUInteger)count {
	// HBLogInfo(@"Method #155");
	return [_notifications count];
}

- (void)recomputeMostRecentDate {
	// HBLogInfo(@"Method #156");
	for (NCNotificationRequest *request in _notifications) {
		if (request.timestamp && [request.timestamp timeIntervalSince1970] > [_recentNotificationDate timeIntervalSince1970]) {
			_recentNotificationDate = request.timestamp;
		}
	}
}

- (NCNotificationRequest *)requestAtIndex:(NSUInteger)index {
	// HBLogInfo(@"Method #157");
	if (index < [_notifications count]) {
		return _notifications[index];
	}
	return nil;
}

- (NCNotificationRequest *)notificationAtIndex:(NSUInteger)index {
	// HBLogInfo(@"Method #158");
	if (index < [_notifications count]) {
		return _notifications[index];
	}
	return nil;
}
@end