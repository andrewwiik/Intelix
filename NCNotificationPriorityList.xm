#import <Intelix/NCNotificationPriorityList.h>
#import <Intelix/ITXNotificationsSection.h>
#import <UserNotificationsKit/NCNotificationRequest.h>
#import <Intelix/ITXHelper.h>
#import <Intelix/NCNotificationCombinedListViewController.h>

// static NSMutableArray *notifSections;
// NSUInteger cachedCount = 0;

// static NSMutableOrderedSet *allNotifs;

// @interface NCNotificationPriorityList ()
// @property (nonatomic, retain) NSMutableArray *lSections;
// @end

%hook NCNotificationPriorityList
%property (nonatomic, retain) NCNotificationCombinedListViewController *controller;
%property (nonatomic, retain) NSMutableArray *lSections;

// %new
// - (void)recomputeCount {
// 	HBLogInfo(@"Method #201");
// 	NSUInteger count = 0;
// 	NSMutableArray *sections = self.sections;
// 	allNotifs = [NSMutableOrderedSet new];
// 	for (ITXNotificationsSection *section in sections) {
// 		count += [section count];
// 		[allNotifs addObjectsFromArray:section.notifications];
// 	}
// 	cachedCount = count;
// }

// - (id)init {
// 	HBLogInfo(@"Method #1");
// 	NCNotificationPriorityList *list = %orig;
// 	if (list) {
// 		self.sections = [NSMutableArray new];
// 	}
// 	return list;
// }

// %new
// - (NSMutableArray *)sections {
// 	HBLogInfo(@"Method #2");
// 	return notifSections;
// 	NSMutableArray *sections = self.lSections;
// 	if (!sections) {
// 		// HBLogInfo(@"Sections was NULL");
// 	} else {
// 		// HBLogInfo(@"Sections was not NULL");
// 	}
// 	return sections;
// }

// %new
// - (void)setSections:(NSMutableArray *)sections {
// 	// HBLogInfo(@"Method #3");
// 	notifSections = sections;
// }

%new
- (NSUInteger)sectionCount {
	return 1;
	HBLogInfo(@"Method #4");
	NSUInteger count = [self.sections count];
	return count > 0 ? count : 1;
	// return [self.sections count];
}

// %new
// - (NSUInteger)rowCountForSectionIndex:(NSUInteger)section {
// 	HBLogInfo(@"Method #5");
// 	NSUInteger maxCount = [self.sections count];
// 	if (section < maxCount) {
// 		return [self.sections[section] count];
// 	} else return 0;
// }

// %new
// - (NSUInteger)actualCountInSection:(NSUInteger)section {
// 	// HBLogInfo(@"Method #6");
// 	NSUInteger maxCount = [self.sections count];
// 	if (section < maxCount) {
// 		return [self.sections[section] count];
// 	} else return 0;
// }

// %new
// - (NCNotificationRequest *)notificationRequestAtIndexPath:(NSIndexPath *)indexPath {
// 	HBLogInfo(@"Method #7");
// 	NSUInteger maxCount = [self.sections count];
// 	if ([indexPath section] < maxCount) {
// 		return [self.sections[[indexPath section]] notificationAtIndex:[indexPath row]];
// 	} else return nil;
// }

// %new
// - (NSIndexPath *)indexPathForNotificationRequest:(NCNotificationRequest *)request {
// 	HBLogInfo(@"Method #8");
// 	NSUInteger maxCount = [self.sections count];
// 	for (NSUInteger x = 0; x < maxCount; x++) {
// 		ITXNotificationsSection *section = self.sections[x];
// 		NSUInteger index = [section indexOfNotification:request];
// 		if (index != NSNotFound) {
// 			return [NSIndexPath indexPathForRow:index inSection:x];
// 		}
// 	}
// 	return nil;
// }

// %new
// - (ITXNotificationsSection *)existingSectionForRequest:(NCNotificationRequest *)request {
// 	HBLogInfo(@"Method #9");
// 	NSMutableArray *sections = self.sections;
// 	for (ITXNotificationsSection *section in sections) {
// 		if ([section.identifier isEqualToString:request.sectionIdentifier]) return section;
// 	}
// 	return nil;
// }

// %new
// - (ITXNotificationsSection *)newSectionForRequest:(NCNotificationRequest *)request {
// 	HBLogInfo(@"Method #10");
// 	ITXNotificationsSection *section = [[ITXNotificationsSection alloc] init];
// 	section.title = request.content.header;
// 	section.identifier = request.sectionIdentifier;
// 	section.icon = request.content.icon;
// 	return section;
// }

// - (NCNotificationRequest *)requestAtIndex:(NSUInteger)index {
// 	HBLogInfo(@"Method #11");
// 	NSUInteger maxCount = [self.sections count];
// 	if (maxCount > 0) {
// 		NSUInteger count = 0;
// 		for (NSUInteger x = 0; x < maxCount; x++) {
// 			ITXNotificationsSection *section = self.sections[x];
// 			if (index >= count && index < count + [section count]) {
// 				return [section notificationAtIndex:index - count];
// 			} else {
// 				count += [section count];
// 			}
// 		}
// 	}
// 	return nil;
// }

// - (NSUInteger)_indexOfRequestMatchingNotificationRequest:(NCNotificationRequest *)request {
// 	HBLogInfo(@"Method #12");
// 	NSUInteger count = [self.sections count];
// 	for (NSUInteger x = 0; x < count; x++) {
// 		ITXNotificationsSection *section = self.sections[x];
// 		NSUInteger index = [section indexOfNotification:request];
// 		if (index != NSNotFound) {
// 			return [self countOfNotificationsInSectionsBeforeSection:x] + index;
// 		}
// 	}
// 	return NSNotFound;
// }

// %new
// - (NSUInteger)countOfNotificationsInSectionsBeforeSection:(NSUInteger)section {
// 	// HBLogInfo(@"Method #13");
// 	NSUInteger count = 0;
// 	NSUInteger sectionCount = [self.sections count];
// 	for (NSUInteger x = section - 1; x > -1; x--) {
// 		if (x < sectionCount) {
// 			count += [self.sections[x] count];
// 		}
// 	}
// 	return count;
// }

// - (NSUInteger)removeNotificationRequest:(NCNotificationRequest *)request {
// 	NSIndexPath *path = [self itx_removeNotificationRequest:request];
// 	return [path row];
// }

// - (NSUInteger)insertNotificationRequest:(NCNotificationRequest *)request {
// 	NSIndexPath *path = [self itx_insertNotificationRequest:request];
// 	return [path row];
// }

// - (NSUInteger)modifyNotificationRequest:(NCNotificationRequest *)request {
// 	[self itx_modifyNotificationRequest:request];
// 	return NSNotFound;
// }

// %new
// - (NSIndexPath *)itx_removeNotificationRequest:(NCNotificationRequest *)request {
// 	HBLogInfo(@"Method #14");
// 	NSUInteger maxCount = [self.sections count];
// 	NSIndexPath *pathToReturn = nil;
// 	ITXNotificationsSection *sectionToRemove = nil;
// 	for (NSUInteger x = 0; x < maxCount; x++) {
// 		ITXNotificationsSection *section = self.sections[x];
// 		NSUInteger index = [section indexOfNotification:request];
// 		if (index != NSNotFound) {
// 			[section removeNotificationRequest:request];
// 			if ([section count] < 1) {
// 				//[self.sections removeObject:section];
// 				sectionToRemove = section;
// 			}
// 			pathToReturn = [NSIndexPath indexPathForRow:index inSection:x];
// 			break;
// 			//return [self countOfNotificationsInSectionsBeforeSection:x] + index;
// 		}
// 	}

// 	if (sectionToRemove) {
// 		[self.sections removeObject:sectionToRemove];
// 	}
// 	[self recomputeCount];
// 	if (pathToReturn) return pathToReturn;
// 	return nil;
// }

// %new
// - (NSIndexPath *)itx_modifyNotificationRequest:(NCNotificationRequest *)request {
// 	HBLogInfo(@"Method #15");
// 	NSUInteger maxCount = [self.sections count];
// 	for (NSUInteger x = 0; x < maxCount; x++) {
// 		ITXNotificationsSection *section = self.sections[x];
// 		NSUInteger index = [section indexOfNotification:request];
// 		if (index != NSNotFound) {
// 			[section modifyNotificationRequest:request];
// 			[self recomputeCount];
// 			return [NSIndexPath indexPathForRow:index inSection:x];
// 			//return [self countOfNotificationsInSectionsBeforeSection:x] + index;
// 		}
// 	}
// 	[self recomputeCount];
// 	return nil;
// }

// %new
// -(NSIndexPath *)itx_insertNotificationRequest:(NCNotificationRequest *)request {
// 	HBLogInfo(@"Method #16");
// 	ITXNotificationsSection *section = [self existingSectionForRequest:request];
// 	if (section) {
// 		NSUInteger index = [self.sections indexOfObject:section];
// 		[self.sections removeObjectAtIndex:index];
// 		[self.sections insertObject:section atIndex:0];
// 	} else {
// 		section = [self newSectionForRequest:request];
// 		[self.sections insertObject:section atIndex:0];
// 	}

// 	[section insertNotificationRequest:request];

// 	NSUInteger index = [section indexOfNotification:request];
// 	// NSUInteger x = [self.sections indexOfObject:section];
// 	NSUInteger indexS = [self.sections indexOfObject:section];
// 	[self.sections removeObjectAtIndex:indexS];
// 	[self.sections insertObject:section atIndex:0];

// 	[ITXHelper setIcon:request.content.icon forIdentifier:request.sectionIdentifier];
// 	[self recomputeCount];
// 	return [NSIndexPath indexPathForRow:index inSection:0];
// 	//return [self countOfNotificationsInSectionsBeforeSection:x] + index;
// }

// %new
// - (BOOL)containsNotificationRequest:(NCNotificationRequest *)request {
// 	HBLogInfo(@"Method #17");
// 	NSMutableArray *sections = self.sections;
// 	for (ITXNotificationsSection *section in sections) {
// 		if ([section indexOfNotification:request] != NSNotFound) {
// 			return TRUE;
// 		}
// 	}
// 	return FALSE;
// }

// - (NSMutableOrderedSet *)requests {
// 	HBLogInfo(@"Method #18");
// 	if (!allNotifs) [self recomputeCount];
// 	return allNotifs;
// 	// NSMutableOrderedSet *requests = [NSMutableOrderedSet new];
// 	// NSMutableArray *sections = self.sections;
// 	// for (ITXNotificationsSection *section in sections) {
// 	// 	[requests addObjectsFromArray:section.notifications];
// 	// }
// 	// return requests;
// }

// - (NSUInteger)count {
// 	HBLogInfo(@"Method #19");
// 	return cachedCount;
// }

// - (id)clearNonPersistentRequests {
// 	HBLogInfo(@"Method #20");
// 	return %orig;
// }

// - (NSMutableSet *)clearRequestsPassingTest:(/*^block*/ id)arg1 {
// 	HBLogInfo(@"Method #21");
// 	NSMutableSet *cleared = %orig;
// 	NSArray *requests = [cleared allObjects];
// 	for (NCNotificationRequest *request in requests) {
// 		[self itx_removeNotificationRequest:request];
// 	}
// 	//NSMutableArray *removedPaths = [NSMutableArray new];

// 	// for (NCNotificationRequest *request in cleared) {
// 	// 	NSIndexPath *path = [self itx_removeNotificationRequest:request];
// 	// 	if (path) [removedPaths addObject:path];
// 	// }


// 	// HBLogInfo(@"Clearing Notifications Passing Test");
// 	[self recomputeCount];
// 	// for (NSIndexPath *path in removedPaths) {
// 	// 	// HBLogInfo(@"Removed Index with Test: %@", path);
// 	// }
// 	// if (self.controller) {
// 	// 	[self.controller.collectionView reloadData];
// 	// }
// 	return cleared;
// }

// - (NSMutableSet *)_clearRequestsWithPersistence:(NSUInteger)persistance {
// 	HBLogInfo(@"Method #22");
// 	NSMutableSet *removed = [NSMutableSet new];
// 	NSMutableArray *sections = self.sections;
// 	for (ITXNotificationsSection *section in sections) {
// 		NSMutableArray *notifications = [section.notifications mutableCopy];
// 		for (NCNotificationRequest *request in notifications) {
// 			if (request.options && request.options.lockScreenPersistence == persistance) {
// 				[removed addObject:request];
// 				//[section removeNotificationRequest:request];
// 			}
// 		}
// 	}

// 	// NSMutableArray *newSections = [NSMutableArray new];

// 	// for (ITXNotificationsSection *section in sections) {
// 	// 	if ([section count] > 0) {
// 	// 		[newSections addObject:section];
// 	// 	} else {

// 	// 	}
// 	// }

// 	// self.sections = newSections;

// 	// HBLogInfo(@"Clearing Notifications with Persistance");

// 	// if (self.controller) {
// 	// 	[self.controller.collectionView reloadData];
// 	// }
// 	[self recomputeCount];
// 	return removed;
// }

// %new
// - (NSString *)titleForSectionIndex:(NSUInteger)section {
// 	HBLogInfo(@"Method #23");
// 	if (section < [self.sections count]) {
// 		NSString *title = [self.sections[section] title];
// 		NSString *identifier = [self.sections[section] identifier];
// 		return [NSString stringWithFormat:@"%@|%@", title, identifier];
// 	}
// 	return @"";
// }

// %new
// - (NSString *)identifierForSectionIndex:(NSUInteger)section {
// 	HBLogInfo(@"Method #24");
// 	if (section < [self.sections count]) {
// 		return [self.sections[section] identifier];
// 	}
// 	return @"";
// }

// %new
// - (void)clearNotificationsInSection:(NSUInteger)section {
// 	if (section < [self.sections count]) {
// 		[self.sections removeObjectAtIndex:section];
// 		[self recomputeCount];
// 		if (self.controller) {
// 			[self.controller notificationSectionList:self didRemoveSectionAtIndex:section];
// 		}
// 	}
// 	return;
// }
%end