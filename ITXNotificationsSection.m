#import <Intelix/ITXNotificationsSection.h>

@implementation ITXNotificationsSection
- (id)init {
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
	if (notification) { 
		[_notifications insertObject:notification atIndex:0];
	}
	[self recomputeMostRecentDate];

}
- (void)removeNotificationRequest:(NCNotificationRequest *)notification {
	for (NSUInteger x = 0; x < [_notifications count]; x++) {
		if ([_notifications[x].notificationIdentifier isEqualToString:notification.notificationIdentifier]) {
			[_notifications removeObjectAtIndex:x];
			[self recomputeMostRecentDate];
			return;
		}
	}

}
- (void)modifyNotificationRequest:(NCNotificationRequest *)notification {
	for (NSUInteger x = 0; x < [_notifications count]; x++) {
		if ([_notifications[x].notificationIdentifier isEqualToString:notification.notificationIdentifier]) {
			[_notifications replaceObjectAtIndex:x withObject:notification];
			[self recomputeMostRecentDate];
			return;
		}
	}
}
- (NSUInteger)indexOfNotification:(NCNotificationRequest *)notification {
	for (NSUInteger x = 0; x < [_notifications count]; x++) {
		if ([_notifications[x].notificationIdentifier isEqualToString:notification.notificationIdentifier]) {
			return x;
		}
	}
	return NSNotFound;
}

- (NSUInteger)count {
	return [_notifications count];
}

- (void)recomputeMostRecentDate {
	for (NCNotificationRequest *request in _notifications) {
		if (request.timestamp && [request.timestamp timeIntervalSince1970] > [_recentNotificationDate timeIntervalSince1970]) {
			_recentNotificationDate = request.timestamp;
		}
	}
}

- (NCNotificationRequest *)requestAtIndex:(NSUInteger)index {
	if (index < [_notifications count]) {
		return _notifications[index];
	}
	return nil;
}

- (NCNotificationRequest *)notificationAtIndex:(NSUInteger)index {
	if (index < [_notifications count]) {
		return _notifications[index];
	}
	return nil;
}
@end