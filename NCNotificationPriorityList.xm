#import <Intelix/NCNotificationPriorityList.h>
#import <Intelix/ITXNotificationsSection.h>
#import <UserNotificationsKit/NCNotificationRequest.h>
#import <Intelix/ITXHelper.h>

static NSMutableArray *notifSections;

%hook NCNotificationPriorityList

- (id)init {
	NCNotificationPriorityList *list = %orig;
	if (list) {
		self.sections = [NSMutableArray new];
	}
	return list;
}

%new
- (NSMutableArray *)sections {
	return notifSections;
}

%new
- (void)setSections:(NSMutableArray *)sections {
	notifSections = sections;
}

%new
- (NSUInteger)sectionCount {
	NSUInteger count = [self.sections count];
	return count > 0 ? count : 1;
	// return [self.sections count];
}

%new
- (NSUInteger)rowCountForSectionIndex:(NSUInteger)section {
	NSUInteger maxCount = [self.sections count];
	if (section < maxCount) {
		return [self.sections[section] count];
	} else return 0;
}

%new
- (NSUInteger)actualCountInSection:(NSUInteger)section {
	NSUInteger maxCount = [self.sections count];
	if (section < maxCount) {
		return [self.sections[section] count];
	} else return 0;
}

%new
- (NCNotificationRequest *)notificationRequestAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger maxCount = [self.sections count];
	if ([indexPath section] < maxCount) {
		return [self.sections[[indexPath section]] notificationAtIndex:[indexPath row]];
	} else return nil;
}

%new
- (NSIndexPath *)indexPathForNotificationRequest:(NCNotificationRequest *)request {
	NSUInteger maxCount = [self.sections count];
	for (NSUInteger x = 0; x < maxCount; x++) {
		ITXNotificationsSection *section = self.sections[x];
		NSUInteger index = [section indexOfNotification:request];
		if (index != NSNotFound) {
			return [NSIndexPath indexPathForRow:index inSection:x];
		}
	}
	return nil;
}

%new
- (ITXNotificationsSection *)existingSectionForRequest:(NCNotificationRequest *)request {
	NSMutableArray *sections = self.sections;
	for (ITXNotificationsSection *section in sections) {
		if ([section.identifier isEqualToString:request.sectionIdentifier]) return section;
	}
	return nil;
}

%new
- (ITXNotificationsSection *)newSectionForRequest:(NCNotificationRequest *)request {
	ITXNotificationsSection *section = [[ITXNotificationsSection alloc] init];
	section.title = request.content.header;
	section.identifier = request.sectionIdentifier;
	section.icon = request.content.icon;
	return section;
}

- (NCNotificationRequest *)requestAtIndex:(NSUInteger)index {
	NSUInteger maxCount = [self.sections count];
	if (maxCount > 0) {
		NSUInteger count = 0;
		for (NSUInteger x = 0; x < maxCount; x++) {
			ITXNotificationsSection *section = self.sections[x];
			if (index >= count && index < count + [section count]) {
				return [section notificationAtIndex:index - count];
			} else {
				count += [section count];
			}
		}
	}
	return nil;
}

- (NSUInteger)_indexOfRequestMatchingNotificationRequest:(NCNotificationRequest *)request {
	NSUInteger count = [self.sections count];
	for (NSUInteger x = 0; x < count; x++) {
		ITXNotificationsSection *section = self.sections[x];
		NSUInteger index = [section indexOfNotification:request];
		if (index != NSNotFound) {
			return [self countOfNotificationsInSectionsBeforeSection:x] + index;
		}
	}
	return NSNotFound;
}

%new
- (NSUInteger)countOfNotificationsInSectionsBeforeSection:(NSUInteger)section {
	NSUInteger count = 0;
	NSUInteger sectionCount = [self.sections count];
	for (NSUInteger x = section - 1; x > -1; x--) {
		if (x < sectionCount) {
			count += [self.sections[x] count];
		}
	}
	return count;
}

%new
- (NSIndexPath *)itx_removeNotificationRequest:(NCNotificationRequest *)request {
	NSUInteger maxCount = [self.sections count];
	for (NSUInteger x = 0; x < maxCount; x++) {
		ITXNotificationsSection *section = self.sections[x];
		NSUInteger index = [section indexOfNotification:request];
		if (index != NSNotFound) {
			[section removeNotificationRequest:request];
			if ([section count] < 1) {
				[self.sections removeObject:section];
			}
			return [NSIndexPath indexPathForRow:index inSection:x];
			//return [self countOfNotificationsInSectionsBeforeSection:x] + index;
		}
	}
	return nil;
}

%new
- (NSIndexPath *)itx_modifyNotificationRequest:(NCNotificationRequest *)request {
	NSUInteger maxCount = [self.sections count];
	for (NSUInteger x = 0; x < maxCount; x++) {
		ITXNotificationsSection *section = self.sections[x];
		NSUInteger index = [section indexOfNotification:request];
		if (index != NSNotFound) {
			[section modifyNotificationRequest:request];
			return [NSIndexPath indexPathForRow:index inSection:x];
			//return [self countOfNotificationsInSectionsBeforeSection:x] + index;
		}
	}
	return nil;
}

%new
-(NSIndexPath *)itx_insertNotificationRequest:(NCNotificationRequest *)request {
	ITXNotificationsSection *section = [self existingSectionForRequest:request];
	if (section) {
		NSUInteger index = [self.sections indexOfObject:section];
		[self.sections removeObjectAtIndex:index];
		[self.sections insertObject:section atIndex:0];
	} else {
		section = [self newSectionForRequest:request];
		[self.sections insertObject:section atIndex:0];
	}

	[section insertNotificationRequest:request];

	NSUInteger index = [section indexOfNotification:request];
	// NSUInteger x = [self.sections indexOfObject:section];
	NSUInteger indexS = [self.sections indexOfObject:section];
	[self.sections removeObjectAtIndex:indexS];
	[self.sections insertObject:section atIndex:0];

	[ITXHelper setIcon:request.content.icon forIdentifier:request.sectionIdentifier];
	return [NSIndexPath indexPathForRow:index inSection:0];
	//return [self countOfNotificationsInSectionsBeforeSection:x] + index;
}

%new
- (BOOL)containsNotificationRequest:(NCNotificationRequest *)request {
	NSMutableArray *sections = self.sections;
	for (ITXNotificationsSection *section in sections) {
		if ([section indexOfNotification:request] != NSNotFound) {
			return TRUE;
		}
	}
	return FALSE;
}

- (NSMutableOrderedSet *)requests {
	NSMutableOrderedSet *requests = [NSMutableOrderedSet new];
	NSMutableArray *sections = self.sections;
	for (ITXNotificationsSection *section in sections) {
		[requests addObjectsFromArray:section.notifications];
	}
	return requests;
}

- (NSUInteger)count {
	NSUInteger count = 0;
	NSMutableArray *sections = self.sections;
	for (ITXNotificationsSection *section in sections) {
		count += [section count];
	}
	return count;
}

- (id)_clearRequestsWithPersistence:(NSUInteger)persistance {
	return [NSMutableArray new];
}

- (id)clearNonPersistentRequests {
	return [NSMutableArray new];
}

- (id)clearRequestsPassingTest:(/*^block*/ id)arg1 {
	return [NSMutableArray new];
}

%new
- (NSString *)titleForSectionIndex:(NSUInteger)section {
	if (section < [self.sections count]) {
		NSString *title = [self.sections[section] title];
		NSString *identifier = [self.sections[section] identifier];
		return [NSString stringWithFormat:@"%@|%@", title, identifier];
	}
	return @"";
}

%new
- (NSString *)identifierForSectionIndex:(NSUInteger)section {
	if (section < [self.sections count]) {
		return [self.sections[section] identifier];
	}
	return @"";
}
%end