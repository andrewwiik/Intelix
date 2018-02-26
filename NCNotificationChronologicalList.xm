#import <Intelix/NCNotificationChronologicalList.h>
#import <Intelix/NCNotificationCombinedListViewController.h>
#import <Intelix/NCNotificationListSection.h>
#import <UserNotificationsKit/NCNotificationRequest.h>
#import <Intelix/ITXHelper.h>

%hook NCNotificationChronologicalList
%property (nonatomic, retain) NSMutableArray *collapsedSectionIdentifiers;
%property (nonatomic, retain) NSMutableArray *expandedSectionIdentifiers;

%new
-(id)clearAllRequests {
	return nil;
}

%new
-(id)clearNonPersistentRequests {
	return nil;
}

%new
-(id)_clearRequestsWithPersistence:(NSUInteger)arg1 {
	return nil;
}

-(id)init {
	NCNotificationChronologicalList *orig = %orig;
	if (orig) {
		orig.collapsedSectionIdentifiers = [NSMutableArray new];
		orig.expandedSectionIdentifiers = [NSMutableArray new];
	}
	return orig;
}

- (NCNotificationListSection *)_existingSectionForNotificationRequest:(NCNotificationRequest *)request {
	//return nil;
	id r = %orig;
	NSLog(@"STUFF %@", r);
	NSArray *sections = [self sections];
	if (sections && [sections count] > 0) {
		for (NCNotificationListSection *section in sections) {
			if ([section.otherSectionIdentifier isEqualToString:request.sectionIdentifier]) {
				return section;
			}
		}
	}
	return nil;
}

- (NCNotificationListSection *)_newSectionForNotificationRequest:(NCNotificationRequest *)request {
	NCNotificationListSection *sec = %orig;
	NSString *identifier = request.sectionIdentifier;
	if (!identifier) {
		identifier = @"com.apple.unknown";
	}
	NSString *name = @"Unknown";
	if (request.content) {
		if (request.content.header) {
			name = request.content.header;
		}
		sec.iconImage = request.content.icon;
	}

	name = [NSString stringWithFormat:@"%@|%@", name, identifier];

	NCNotificationListSection *section = [[NSClassFromString(@"NCNotificationListSection") alloc] initWithIdentifier:identifier title:name];
	[section setSectionDate:[sec sectionDate]];
	sec.otherSectionIdentifier = identifier;
	sec.title = name;

	return sec;
}

%new
- (BOOL)sectionIsCollapsed:(NSUInteger)sectionIndex {
	if (sectionIndex < [self.sections count]) {
		NCNotificationListSection *section = [self.sections objectAtIndex:sectionIndex];
		if (section) {
			if ([self.collapsedSectionIdentifiers containsObject:section.otherSectionIdentifier]) {
				return YES;
			}
		}
	}
	return NO;
}

%new
- (BOOL)sectionIsExpanded:(NSUInteger)sectionIndex {
	if (sectionIndex < [self.sections count]) {
		NCNotificationListSection *section = [self.sections objectAtIndex:sectionIndex];
		if (section) {
			if ([self.expandedSectionIdentifiers containsObject:section.otherSectionIdentifier]) {
				return YES;
			}
		}
	}
	return NO;
}

%new
- (NSUInteger)actualNumberOfNotificationsInSection:(NSUInteger)sectionIndex {
	if (sectionIndex < [self.sections count]) {
		NCNotificationListSection *section = [self.sections objectAtIndex:sectionIndex];
		return [section count];
	}
	return 0;
}

%new
- (NSString *)otherSectionIdentifierForSectionIndex:(NSUInteger)sectionIndex {
	if (sectionIndex < [self.sections count]) {
		return [self.sections objectAtIndex:sectionIndex].otherSectionIdentifier;
	}
	return @"";
}

%new
- (NSUInteger)sectionIndexForOtherSectionIdentifier:(NSString *)otherSectionIdentifier {

	for (NCNotificationListSection *section in self.sections) {
		if ([section.otherSectionIdentifier isEqualToString:otherSectionIdentifier]) {
			return [self.sections indexOfObject:section];
		}
	}
	return [self.sections count];
}

%new
- (void)toggleExpansionForSectionIdentifier:(NSString *)sectionIdentifier {
	if ([self.collapsedSectionIdentifiers containsObject:sectionIdentifier]) {
		[self.collapsedSectionIdentifiers removeObject:sectionIdentifier];
		[self.expandedSectionIdentifiers addObject:sectionIdentifier];
		NSMutableArray *indexPaths = [NSMutableArray new];
		NSUInteger sectionIndex = [self sectionIndexForOtherSectionIdentifier:sectionIdentifier];
		NSUInteger numOfItemsToShow = [[self.sections objectAtIndex:sectionIndex] count] - 3;
		for (int x = 0; x < numOfItemsToShow; x++) {
			[indexPaths addObject:[NSIndexPath indexPathForRow:x + 3 inSection:sectionIndex]];
		}

		NSArray *reloadPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 - 1 inSection:sectionIndex], nil];

		[self.delegate notificationSectionList:self didInsertNotificationRequests:nil atIndexPaths:[indexPaths copy] reloadIndexPaths:reloadPaths];

	} else {
		if ([self.expandedSectionIdentifiers containsObject:sectionIdentifier]) {
			[self.expandedSectionIdentifiers removeObject:sectionIdentifier];
		}
		[self.collapsedSectionIdentifiers addObject:sectionIdentifier];

		NSMutableArray *indexPaths = [NSMutableArray new];
		NSUInteger sectionIndex = [self sectionIndexForOtherSectionIdentifier:sectionIdentifier];
		NSUInteger numOfItemsToShow = [[self.sections objectAtIndex:sectionIndex] count] - 3;
		for (int x = 0; x < numOfItemsToShow; x++) {
			[indexPaths addObject:[NSIndexPath indexPathForRow:x + 3 inSection:sectionIndex]];
		}

		NSArray *reloadPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 - 1 inSection:sectionIndex], nil];

		[self.delegate notificationSectionList:self didRemoveNotificationRequests:nil atIndexPaths:[indexPaths copy] reloadIndexPaths:reloadPaths];
	}
}

%new
- (BOOL)sectionHasFooter:(NSUInteger)sectionIndex {
	//return NO;
	if (sectionIndex < [self.sections count]) {
		NCNotificationListSection *section = [self.sections objectAtIndex:sectionIndex];
		if (section) {
			if ([self.expandedSectionIdentifiers containsObject:section.otherSectionIdentifier]) {
				return YES;
			}
			if ([self.collapsedSectionIdentifiers containsObject:section.otherSectionIdentifier]) {
				return YES;
			}
		}
	}
	return NO;
}


// - (id)_sectionContainingNotificationRequest:(id)request {
// 	//return nil;
// 	return nil;
// }

- (NSUInteger)rowCountForSectionIndex:(NSUInteger)sectionIndex {
	NSUInteger orig = %orig;
	if (orig >= 3) {
		NCNotificationListSection *section = [self.sections objectAtIndex:sectionIndex];
		if (section) {
			if ([self.collapsedSectionIdentifiers containsObject:section.otherSectionIdentifier]) {
				orig = 3;
			} else if (![self.expandedSectionIdentifiers containsObject:section.otherSectionIdentifier]) {
				return 3;
			}
		}
	}
	return orig;
}

- (id)insertNotificationRequest:(NCNotificationRequest *)request {
	
	NSString *sectionIdentifier = request.sectionIdentifier;
	[ITXHelper setIcon:request.content.icon forIdentifier:request.sectionIdentifier];
	//[iconToID setObject:request.content.icon forKey:request.sectionIdentifier];
	if ([self _existingSectionForNotificationRequest:request]) {
		if (![self.expandedSectionIdentifiers containsObject:sectionIdentifier] && ![self.collapsedSectionIdentifiers containsObject:sectionIdentifier]) {
			NSUInteger sectionIndex = [self sectionIndexForOtherSectionIdentifier:request.sectionIdentifier];
			if (sectionIndex < [self.sections count]) {
				NCNotificationListSection *section = [self.sections objectAtIndex:sectionIndex];
				if ([section count] + 1 > 3) {
					[self.collapsedSectionIdentifiers addObject:sectionIdentifier];
				}
			}
		}
	}

	id orig = %orig;
	return orig;
}

- (id)removeNotificationRequest:(NCNotificationRequest *)request {
	NSString *sectionIdentifier = request.sectionIdentifier;
	if (sectionIdentifier) {
		if ([self.expandedSectionIdentifiers containsObject:sectionIdentifier] || [self.collapsedSectionIdentifiers containsObject:sectionIdentifier]) {
			NSUInteger sectionIndex = [self sectionIndexForOtherSectionIdentifier:request.sectionIdentifier];
			if (sectionIndex < [self.sections count]) {
				NCNotificationListSection *section = [self.sections objectAtIndex:sectionIndex];
				if ([section count] - 1 < 4) {
					if ([self.collapsedSectionIdentifiers containsObject:sectionIdentifier]) {
						[self.collapsedSectionIdentifiers removeObject:sectionIdentifier];
					}

					if ([self.expandedSectionIdentifiers containsObject:sectionIdentifier]) {
						[self.expandedSectionIdentifiers removeObject:sectionIdentifier];
					}
				}
			} else {
				if ([self.collapsedSectionIdentifiers containsObject:sectionIdentifier]) {
					[self.collapsedSectionIdentifiers removeObject:sectionIdentifier];
				}

				if ([self.expandedSectionIdentifiers containsObject:sectionIdentifier]) {
					[self.expandedSectionIdentifiers removeObject:sectionIdentifier];
				}
			}
		}
	}
	id orig = %orig;
	return orig;
}
%end