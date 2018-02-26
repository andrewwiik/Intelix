#import <UserNotificationsKit/NCNotificationRequest.h>
#import <UIKit/UICollectionView+Private.h>
#import <Intelix/NCNotificationCombinedListViewController.h>
#import <Intelix/NCNotificationListCell.h>
#import <Intelix/NCNotificationChronologicalList.h>
#import <Intelix/ITXNCGroupFooterView.h>
#import <Intelix/ITXNCGroupBackgroundView.h>
#import <Intelix/ITXNCGroupBackgroundConfiguration.h>
#import <Intelix/NCNotificationPriorityList.h>
#import <Intelix/NCNotificationListSectionHeaderView.h>

static BOOL isIOS11 = YES;

%hook NCNotificationCombinedListViewController
- (BOOL)_isNotificationRequestForLockScreenNotificationDestination:(NCNotificationRequest *)request {
	BOOL orig = %orig;
	return orig;
	// return orig;
	if (orig) {
		self.showingNotificationsHistory = YES;
		//[self _revealNotificationsHistory];
	}
	return NO;
	// return NO;
}

%new
- (id)sectionList {
	return [self notificationSectionList];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout referenceSizeForHeaderInSection:(NSUInteger)section {
	if (section > [self.notificationPriorityList sectionCount] - 1) return %orig;
	else {
		if ([collectionView numberOfItemsInSection:section] > 0) {
			return CGSizeMake(collectionView.bounds.size.width, 60);
		} else {
			return CGSizeZero;
		}
	}
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(NCNotificationListCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath  {
	if ([cell isKindOfClass:NSClassFromString(@"NCNotificationListCell")]) {
		cell.hasFooterUnder = [self.sectionList sectionHasFooter:[self _adjustedSectionIndexForListOperation:[indexPath section]]];
		cell.isLastInSection = [self collectionView:collectionView numberOfItemsInSection:[indexPath section]] - 1 == [indexPath row];
		cell._isFirstInSection = [indexPath row] == 0;
		//cell.hasFooterUnder = [self.sectionList sectionIsCollapsed:[indexPath section]];
		// cell.cellOver = nil;
		// cell.cellUnder = nil;
	}
	%orig;
}

-(id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
	NCNotificationListCell *cell = %orig;
	if ([cell isKindOfClass:NSClassFromString(@"NCNotificationListCell")]) {
		cell.hasFooterUnder = [self.sectionList sectionHasFooter:[self _adjustedSectionIndexForListOperation:[indexPath section]]];
		cell.isLastInSection = [self collectionView:collectionView numberOfItemsInSection:[indexPath section]] - 1 == [indexPath row];
		cell._isFirstInSection = [indexPath row] == 0;
		if ([indexPath section] > [self.notificationPriorityList sectionCount] - 1) {
			//cell.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
			cell.hidden = self.showingNotificationsHistory ? NO : YES;
		} else {
			cell.hidden = NO;
			// cell.alpha = 1.0;
		}
		//cell.hasFooterUnder = [self.sectionList sectionIsCollapsed:[indexPath section]];
		// cell.cellOver = nil;
		// cell.cellUnder = nil;
	}
	return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(NCNotificationListCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath  {
	%orig;
	if ([cell isKindOfClass:NSClassFromString(@"NCNotificationListCell")]) {
		cell.hasFooterUnder = [self.sectionList sectionHasFooter:[self _adjustedSectionIndexForListOperation:[indexPath section]]];
		int numInSection = [self collectionView:collectionView numberOfItemsInSection:[indexPath section]];
		cell.isLastInSection = numInSection - 1 == [indexPath row];
		cell._isFirstInSection = [indexPath row] == 0;
		//cell.hasFooterUnder = [self.sectionList sectionIsCollapsed:[indexPath section]];
		// cell.cellOver = nil;
		// cell.cellUnder = nil;
	}
}

-(UIView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	// return %orig;

	if (kind && [kind isEqualToString:@"UICollectionElementKindSectionHeader"]) {
		if ([self.collectionView numberOfItemsInSection:[indexPath section]] > 0) {
			NCNotificationListSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"NotificationListSectionHeaderReuseIdentifier" forIndexPath:indexPath];
			headerView.delegate = self;
			if ([indexPath section] > [self.notificationPriorityList sectionCount] - 1) {
				headerView.overrideAlpha = self.showingNotificationsHistory ? 1.0 : 0.0;
				[headerView setTitle:[self.sectionList titleForSectionIndex:[self _adjustedSectionIndexForListOperation:[indexPath section]]] forSectionIdentifier:[self.sectionList identifierForSectionIndex:[self _adjustedSectionIndexForListOperation:[indexPath section]]]];
			} else {
				headerView.overrideAlpha = 1.0;
				headerView.hidden = NO;
				[headerView setTitle:[self.notificationPriorityList titleForSectionIndex:[indexPath section]] forSectionIdentifier:[self.notificationPriorityList identifierForSectionIndex:[indexPath section]]];
				// [headerView setTitle:]
			}
			return headerView;
		}
	}
	if (kind && [kind isEqualToString:[ITXNCGroupBackgroundView elementKind]] && [self.collectionView numberOfItemsInSection:[indexPath section]] > 0) {
		ITXNCGroupBackgroundView *backgroundView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ITXNCGroupBackgroundViewReuseIdentifier" forIndexPath:indexPath];
		backgroundView.isSectionBackground = YES;
		// if ([indexPath section] > [self.notificationPriorityList sectionCount] - 1) {
		// 	// backgroundView.isSectionBackground = YES;
		// 	backgroundView.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
		// } else {
		// 	backgroundView.alpha = 1.0;
		// }
		return backgroundView;
	}

	if (isIOS11 && [indexPath section] < 1) return nil;

	if (kind == UICollectionElementKindSectionFooter) {
		if ([self.sectionList sectionHasFooter:[self _adjustedSectionIndexForListOperation:[indexPath section]]]) {
			ITXNCGroupFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NotificationListSectionHFooterReuseIdentifier" forIndexPath:indexPath];
			footerView.numberToShow = [self.sectionList actualNumberOfNotificationsInSection:[self _adjustedSectionIndexForListOperation:[indexPath section]]] - 3;
			footerView.cellDelegate = self;
			footerView.sectionIdentifier = [self.sectionList otherSectionIdentifierForSectionIndex:[self _adjustedSectionIndexForListOperation:[indexPath section]]];
			footerView.isExpanded = [self.sectionList sectionIsExpanded:[self _adjustedSectionIndexForListOperation:[indexPath section]]];
			footerView.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
			return footerView;
		}
	}
	return nil;

	// return %orig;
	// return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	if (section > [self.notificationPriorityList sectionCount] - 1) {
		if ([self.sectionList sectionHasFooter:[self _adjustedSectionIndexForListOperation:section]]) {
			return CGSizeMake(collectionView.frame.size.width - 8*2, 36);
		}
	} 
	return CGSizeZero;
}

- (void)viewDidLoad {
	%orig;
	[[self collectionView] registerClass:[ITXNCGroupFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NotificationListSectionHFooterReuseIdentifier"];
	[[self collectionView] registerClass:[ITXNCGroupBackgroundView class] forSupplementaryViewOfKind:[ITXNCGroupBackgroundView elementKind] withReuseIdentifier:@"ITXNCGroupBackgroundViewReuseIdentifier"];
}

%new
-(void)sectionFooterView:(ITXNCGroupFooterView *)footerView didReceiveToggleExpansionActionForSectionIdentifier:(NSString *)sectionIdentifier {
	[self.sectionList toggleExpansionForSectionIdentifier:sectionIdentifier];
}

- (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didInsertNotificationRequest:(NCNotificationRequest *)request atIndexPath:(NSIndexPath *)path {
	[self _performCollectionViewOperationBlockIfNecessary:^{
		[[[self collectionView] collectionViewLayout] invalidateLayout];
		NSUInteger section = [path section];
		//if (section > 0) {
		if ([self.sectionList sectionIsCollapsed:section]) {
			[[self collectionView] reloadSections:[NSIndexSet indexSetWithIndex:[self _adjustedSectionIndexForCollectionViewOperation:section]]];
		} else {
			NSIndexPath *newPath = [NSIndexPath indexPathForRow:[path row] inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]];
			[[self collectionView] insertItemsAtIndexPaths:[NSArray arrayWithObjects:newPath,nil]];
		}

		if ([self.sectionList sectionIsCollapsed:section]) {
			ITXNCGroupFooterView *footerView = (ITXNCGroupFooterView *)[[self collectionView] _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
			if (footerView) {
				footerView.numberToShow = [self.sectionList actualNumberOfNotificationsInSection:[path section]] - 3;
				footerView.cellDelegate = self;
				footerView.sectionIdentifier = [self.sectionList otherSectionIdentifierForSectionIndex:[path section]];
				footerView.isExpanded = [self.sectionList sectionIsExpanded:[path section]];

				// if (![self.sectionList sectionIsCollapsed:section]) {
				// 	[self.collectionView.collectionViewLayout invalidateLayout];
				// }
			}
		}
		//}
	}];
}

- (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didRemoveNotificationRequest:(NCNotificationRequest *)request atIndexPath:(NSIndexPath *)path {

	HBLogInfo(@"Removed Notification: %@\n IndexPath: %@", request, path);
	// NCNotificationListCell *cell = (NCNotificationListCell *)[[self collectionView] _visibleCellForIndexPath:[self _adjustedSectionIndexPathForCollectionViewOperation:path]];
	// NSLog(@"NOTIFICATION REMOVAL:\n CELL: %@\nPATH: %@\n,ADJUSTED PATH: %@", cell, path, [self _adjustedSectionIndexPathForCollectionViewOperation:path]);

	// if (cell) {
	// 	NSLog(@"NOTIFICATION REMOVAL:\n CELL: %@\nPATH: %@\n,ADJUSTED PATH: %@\nCELL OVER: %@\nCELL UNDER: %@", cell, path, [self _adjustedSectionIndexPathForCollectionViewOperation:path], cell.cellOver, cell.cellUnder);
	// 	if (cell.cellOver && [cell.cellOver respondsToSelector:@selector(itxBackgroundView)]) {
	// 		[((id<ITXHasRoundedBackground>)cell.cellOver).itxBackgroundView setBottomRadius:0];
	// 		[((id<ITXHasRoundedBackground>)cell.cellOver).itxBackgroundView setBottomClipPercent:0];
	// 		NSLog(@"ITX BACKGROUND OVER: %@", ((id<ITXHasRoundedBackground>)cell.cellOver).itxBackgroundView);
	// 	}

	// 	if (cell.cellUnder && [cell.cellUnder respondsToSelector:@selector(itxBackgroundView)]) {
	// 		[((id<ITXHasRoundedBackground>)cell.cellUnder).itxBackgroundView setTopRadius:0];
	// 		[((id<ITXHasRoundedBackground>)cell.cellUnder).itxBackgroundView setTopClipPercent:0];
	// 		NSLog(@"ITX BACKGROUND UNDER: %@", ((id<ITXHasRoundedBackground>)cell.cellUnder).itxBackgroundView);
		
	// 	}

	// 	cell.cellOver = nil;
	// 	cell.cellUnder = nil;
	// }



//5	[[[self collectionView] collectionViewLayout] invalidateLayout];
	//[[[self collectionView] collectionViewLayout] invalidateLayout];
	[self _performCollectionViewOperationBlockIfNecessary:^{
		BOOL hadFooter = NO;
		ITXNCGroupFooterView *footer = (ITXNCGroupFooterView *)[[self collectionView] _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
		if (footer) {
			hadFooter = !footer.isExpanded;
		}
		[[[self collectionView] collectionViewLayout] invalidateLayout];
		//[[[self collectionView] collectionViewLayout] invalidateLayout];
		NSUInteger section = [path section];

		if ([self.sectionList sectionIsCollapsed:section] || (hadFooter && ![self.sectionList sectionHasFooter:section])) {
			NSMutableArray *indexPaths = [NSMutableArray new];

			for (int x = [path row]; x < [self.sectionList rowCountForSectionIndex:section]; x++) {
				[indexPaths addObject:[NSIndexPath indexPathForRow:x inSection:[self _adjustedSectionIndexForCollectionViewOperation:section]]];
			}

			if ([indexPaths count] > 0) {
				HBLogInfo(@"Reloading Items: %@", indexPaths);
				[[self collectionView] reloadItemsAtIndexPaths:[indexPaths copy]];
			} else {

				// NSLog(@"PATH TO BE RELOADED: %@", path);
				// if ([self.sectionList rowCountForSectionIndex:section] >= [path row] + 1) {
				// 	[[self collectionView] reloadItemsAtIndexPaths:@[[self _adjustedSectionIndexPathForCollectionViewOperation:path]]];
				// }
			}
		} else {
			HBLogInfo(@"Deleting Items: %@", @[[self _adjustedSectionIndexPathForCollectionViewOperation:path]]);
			//NSIndexPath *newPath = [NSIndexPath indexPathForRow:[path row] inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]];
			[[self collectionView] deleteItemsAtIndexPaths:@[[self _adjustedSectionIndexPathForCollectionViewOperation:path]]];
			// if ([path row] > 0) {
			// 	[[self collectionView] reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[path row] - 1 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]],nil]];
			// }
			// if ([path row] + 1 < [self.sectionList rowCountForSectionIndex:section]) {
			// 	[[self collectionView] reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[path row] + 1 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]],nil]];
			// }
		}

		//if ([self.sectionList otherSectionIdentifierForSectionIndex:section] == request.sectionIdentifier) {
			ITXNCGroupFooterView *footerView = (ITXNCGroupFooterView *)[[self collectionView] _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
			if (footerView) {
				footerView.numberToShow = [self.sectionList actualNumberOfNotificationsInSection:[path section]] - 3;
				footerView.cellDelegate = self;
				footerView.sectionIdentifier = [self.sectionList otherSectionIdentifierForSectionIndex:[path section]];
				footerView.isExpanded = [self.sectionList sectionIsExpanded:[path section]];
				
				//NCNotificationListCell *lastCell = (NCNotificationListCell *)[[self collectionView] _visibleCellForIndexPath:[NSIndexPath indexPathForRow:[self.sectionList rowCountForSectionIndex:section] - 1 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
				// if (lastCell && [lastCell respondsToSelector:@selector(itxBackgroundView)]) {
				// 	[lastCell.itxBackgroundView setTopRadius:0 bottomRadius:0 withDelay:0];
				// 	lastCell.itxBackgroundView.topClipPercent = 0;
				// 	lastCell.itxBackgroundView.bottomClipPercent = 0;
				// }
				// if ([self.sectionList actualNumberOfNotificationsInSection:section] < 4) {
				// 	[self.collectionView.collectionViewLayout invalidateLayout];
				// 	[self.collectionView setCollectionViewLayout:self.collectionView.collectionViewLayout];
				// }
			} else {
				// NCNotificationListCell *lastCell = (NCNotificationListCell *)[[self collectionView] _visibleCellForIndexPath:[NSIndexPath indexPathForRow:[self.sectionList rowCountForSectionIndex:section] - 1 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
				// if (lastCell && [lastCell respondsToSelector:@selector(itxBackgroundView)]) {
				// 	[lastCell.itxBackgroundView setTopRadius:0 bottomRadius:1 withDelay:0];
				// 	lastCell.itxBackgroundView.topClipPercent = 0;
				// 	lastCell.itxBackgroundView.bottomClipPercent = 0;
				// }
			}
		//}
	}];
}

%new
- (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didInsertNotificationRequests:(NSArray<NCNotificationRequest *> *)requests atIndexPaths:(NSArray<NSIndexPath *> *)paths reloadIndexPaths:(NSArray<NSIndexPath *> *)reloadPaths {
	[self _performCollectionViewOperationBlockIfNecessary:^{

		NSMutableArray *modifiedPaths = [NSMutableArray new];
		for (NSIndexPath *path in paths) {
			[modifiedPaths addObject:[self _adjustedSectionIndexPathForCollectionViewOperation:path]];
		}
		[[self collectionView] insertItemsAtIndexPaths:[modifiedPaths copy]];

		for (NSIndexPath *path in reloadPaths) {
			int numInSection = [self.sectionList rowCountForSectionIndex:[path section]];
			NCNotificationListCell *cell = (NCNotificationListCell *)[[self collectionView] cellForItemAtIndexPath:[self _adjustedSectionIndexPathForCollectionViewOperation:path]];
			if (cell) {
				cell.hasFooterUnder = [self.sectionList sectionHasFooter:[path section]];
				cell.isLastInSection = numInSection - 1 == [path row];
				cell._isFirstInSection = [path row] == 0;
				cell.cellOver = nil;
				cell.cellUnder = nil;
			}
		}
		if ([paths count] > 0) {
			NSIndexPath *path = (NSIndexPath *)[paths objectAtIndex:0];
			path = [NSIndexPath indexPathForRow:0 inSection:[path section]];
			ITXNCGroupFooterView *footerView = (ITXNCGroupFooterView *)[[self collectionView] _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
			if (footerView) {
				footerView.numberToShow = [self.sectionList actualNumberOfNotificationsInSection:[path section]] - 3;
				footerView.cellDelegate = self;
				footerView.sectionIdentifier = [self.sectionList otherSectionIdentifierForSectionIndex:[path section]];
				footerView.isExpanded = [self.sectionList sectionIsExpanded:[path section]];

				// if (![self.sectionList sectionIsCollapsed:section]) {
				// 	[self.collectionView.collectionViewLayout invalidateLayout];
				// }
			}
		}
		// if ([reloadPaths count] > 0) {
		// 	NSUInteger section = [[reloadPaths objectAtIndex:0] section];
		// 	ITXNCGroupFooterView *footer = (ITXNCGroupFooterView *)[[self collectionView] _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
		// 	if (footer) {
		// 		footer.isExpanded = [self.sectionList sectionIsExpanded:section];
		// 	}
		// }
		//[[self collectionView] reloadItemsAtIndexPaths:[paths copy]];
	}];
}

%new
- (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didRemoveNotificationRequests:(NSArray<NCNotificationRequest *> *)requests atIndexPaths:(NSArray<NSIndexPath *> *)paths  reloadIndexPaths:(NSArray<NSIndexPath *> *)reloadPaths {
	[self _performCollectionViewOperationBlockIfNecessary:^{
		NSMutableArray *modifiedPaths = [NSMutableArray new];
		for (NSIndexPath *path in paths) {
			[modifiedPaths addObject:[self _adjustedSectionIndexPathForCollectionViewOperation:path]];
		}
		HBLogInfo(@"Deleting Items A: %@", modifiedPaths);
		[[self collectionView] deleteItemsAtIndexPaths:[modifiedPaths copy]];

		for (NSIndexPath *path in reloadPaths) {
			int numInSection = [self.sectionList rowCountForSectionIndex:[path section]];
			NCNotificationListCell *cell = (NCNotificationListCell *)[[self collectionView] cellForItemAtIndexPath:[self _adjustedSectionIndexPathForCollectionViewOperation:path]];
			if (cell) {
				cell.hasFooterUnder = [self.sectionList sectionHasFooter:[path section]];
				cell.isLastInSection = numInSection - 1 == [path row];
				cell._isFirstInSection = [path row] == 0;
				cell.cellOver = nil;
				cell.cellUnder = nil;
			}
		}


		if ([paths count] > 0) {
			NSIndexPath *path = (NSIndexPath *)[paths objectAtIndex:0];
			path = [NSIndexPath indexPathForRow:0 inSection:[path section]];
			ITXNCGroupFooterView *footerView = (ITXNCGroupFooterView *)[[self collectionView] _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
			if (footerView) {
				footerView.numberToShow = [self.sectionList actualNumberOfNotificationsInSection:[path section]] - 3;
				footerView.cellDelegate = self;
				footerView.sectionIdentifier = [self.sectionList otherSectionIdentifierForSectionIndex:[path section]];
				footerView.isExpanded = [self.sectionList sectionIsExpanded:[path section]];

				// if (![self.sectionList sectionIsCollapsed:section]) {
				// 	[self.collectionView.collectionViewLayout invalidateLayout];
				// }
			}
		}
	}];
}

- (void)_updateSectionHeadersRevealHintingForRevealPercentage:(CGFloat)percentage {
	%orig;
	// NSArray<NSIndexPath *> *paths = [[self collectionView] indexPathsForVisibleSupplementaryElementsOfKind:[ITXNCGroupBackgroundView elementKind]];
	// paths = [self _filteredIndexPathsForAnimationFromIndexPaths:paths];
	// for (NSIndexPath *path in paths) {
	// 	//if (!([path section] < [self.notificationPriorityList sectionCount])) {
	// 		ITXNCGroupBackgroundView *backgroundView = (ITXNCGroupBackgroundView *)[[self collectionView] supplementaryViewForElementKind:[ITXNCGroupBackgroundView elementKind] atIndexPath:path];
	// 		//UICollectionViewLayoutAttributes *attributes = [[self collectionView] layoutAttributesForSupplementaryElementOfKind:[ITXNCGroupBackgroundView elementKind] atIndexPath:indexPath];
	// 		if (backgroundView) {
	// 			UICollectionViewLayoutAttributes *attributes = [[self collectionView] layoutAttributesForSupplementaryElementOfKind:[ITXNCGroupBackgroundView elementKind] atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[path section]]];
	// 			if (attributes) {
	// 				[self _updateSupplementaryView:backgroundView layoutAttributes:attributes forRevealPercentage:percentage atIndexPath:path];
	// 			}
	// 			//[self _updateSupplementaryView:backgroundView layoutAttributes: forRevealPercentage:r15 atIndexPath:r9];
	// 		}
	// 	//}
	// }

	// NSArray<NSIndexPath *> *paths1 = [[self collectionView] indexPathsForVisibleSupplementaryElementsOfKind:@"UICollectionElementKindSectionFooter"];
	// paths1 = [self _filteredIndexPathsForAnimationFromIndexPaths:paths1];
	// for (NSIndexPath *path in paths1) {
	// 	//if (!([path section] < [self.notificationPriorityList sectionCount])) {
	// 		ITXNCGroupFooterView *footerView = (ITXNCGroupFooterView *)[[self collectionView] supplementaryViewForElementKind:@"UICollectionElementKindSectionFooter" atIndexPath:path];
	// 		//UICollectionViewLayoutAttributes *attributes = [[self collectionView] layoutAttributesForSupplementaryElementOfKind:[ITXNCGroupBackgroundView elementKind] atIndexPath:indexPath];
	// 		if (footerView) {
	// 			UICollectionViewLayoutAttributes *attributes = [[self collectionView] layoutAttributesForSupplementaryElementOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[path section]]];
	// 			if (attributes) {
	// 				[self _updateSupplementaryView:footerView layoutAttributes:attributes forRevealPercentage:percentage atIndexPath:path];
	// 			}
	// 			//[self _updateSupplementaryView:backgroundView layoutAttributes: forRevealPercentage:r15 atIndexPath:r9];
	// 		}
	// 	//}
	// }
}

- (BOOL)removeNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
	HBLogInfo(@"Removing Request: %@", request);
	if (request && [self.notificationPriorityList containsNotificationRequest:request]) {
		NSIndexPath *path = [self.notificationPriorityList itx_removeNotificationRequest:request];
		if (path) {
			[[[self collectionView] collectionViewLayout] invalidateLayout];
			[self.collectionView reloadData];
			[self _updatePrioritySectionLowestPosition];
			[self.collectionView layoutSubviews];
			return YES;
		}  else {
			return NO;
		}
	}
	return %orig;
}



- (BOOL)modifyNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
	if ([self.notificationPriorityList containsNotificationRequest:request]) {
		NSIndexPath *path = [self.notificationPriorityList itx_modifyNotificationRequest:request];
		if (path) {
			[[[self collectionView] collectionViewLayout] invalidateLayout];
			[self.collectionView reloadData];
			[self _updatePrioritySectionLowestPosition];
			[self.collectionView layoutSubviews];
			return YES;
		}  else {
			return NO;
		}
	} else {
		return %orig;
	}
}

- (BOOL)insertNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
	//BOOL hasContent = [self hasContent];
	if ([self.notificationPriorityList containsNotificationRequestMatchingRequest:request]) {
		BOOL result = [self modifyNotificationRequest:request forCoalescedNotification:arg2];
		if (result) {
			//if (!hasContent) {
				[self notifyContentObservers];
			//}
		}
		return result;
	} else {
		BOOL isForLockScreen = [self _isNotificationRequestForLockScreenNotificationDestination:request];
		if (isForLockScreen) {
			BOOL sectionListContainsNotification = [self.sectionList containsNotificationRequest:request];
			if (sectionListContainsNotification) {
				[self.sectionList removeNotificationRequest:request];
			}

			if ([self.notificationPriorityList count] < 1) {
				[self _createRequestOperationAnimationCoordinatorForInitialContentPresentation:YES];
			}

			NSIndexPath *insertedPath = [self.notificationPriorityList itx_insertNotificationRequest:request];
			if (insertedPath) {
				BOOL isFirst = NO;
				if ([insertedPath section] == 0 && [insertedPath row] == 0) {
					isFirst = YES;
				}
				if (isFirst) {
					[self _updateRaiseToListenRequest];
				}
				[[[self collectionView] collectionViewLayout] invalidateLayout];
				[self.collectionView reloadData];
				[self _updatePrioritySectionLowestPosition];
				[self.collectionView layoutSubviews];
			}
		}
	}
	return %orig;
}

- (NSUInteger)_adjustedSectionIndexForListOperation:(NSUInteger)sectionIndex {
	sectionIndex -= [self.notificationPriorityList sectionCount];
	return sectionIndex;
}

- (NSUInteger)_adjustedSectionIndexForCollectionViewOperation:(NSUInteger)sectionIndex {
	sectionIndex += [self.notificationPriorityList sectionCount];
	return sectionIndex;
}	

- (NCNotificationRequest *)notificationRequestAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath section] < [self.notificationPriorityList sectionCount]) {
		return [self.notificationPriorityList notificationRequestAtIndexPath:indexPath];
	} else {
		return [self.sectionList notificationRequestAtIndexPath:[self _adjustedSectionIndexPathForListOperation:indexPath]];
	}
}

- (NSUInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	NSUInteger priorityCount = [self.notificationPriorityList sectionCount];
	NSUInteger historyCount = [self.sectionList sectionCount];
	return priorityCount + historyCount;
}

- (NSUInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section {
	if (section < [self.notificationPriorityList sectionCount]) {
		return [self.notificationPriorityList rowCountForSectionIndex:section];
	} else {
		return [self.sectionList rowCountForSectionIndex:[self _adjustedSectionIndexForListOperation:section]];
	}
}

- (NSIndexPath *)indexPathForNotificationRequest:(NCNotificationRequest *)request {
	NSIndexPath *priorityPath = [self.notificationPriorityList indexPathForNotificationRequest:request];
	if (priorityPath != nil) {
		return priorityPath;
	} else {
		return %orig;
	}
}

- (NSMutableArray<NSIndexPath *> *)_filteredIndexPathsForAnimationFromIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
	NSUInteger lastPrioritySection = [self.notificationPriorityList sectionCount] - 1;
	NSMutableArray<NSIndexPath *> *newPaths = [NSMutableArray new];
	for (NSIndexPath *path in indexPaths) {
		if ([path section] > lastPrioritySection) {
			[newPaths addObject:path];
		}
	}
	return newPaths;
}

- (void)viewDidAppear:(BOOL)didAppear {
	%orig;
	if (self.collectionView) {
		[[[self collectionView] collectionViewLayout] invalidateLayout];
		[self.collectionView reloadData];
		[self.collectionView layoutSubviews];
	}
}

- (void)_updatePrioritySectionLowestPosition {
	NSInteger priorityHighestSection = [self.notificationPriorityList sectionCount] - 1;
	UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:[ITXNCGroupBackgroundView elementKind] atIndexPath:[NSIndexPath indexPathForRow:0 inSection:priorityHighestSection]];
	if (attributes) {
		self.prioritySectionLowestPosition = attributes.frame.origin.y + attributes.frame.size.height;
	}
}
%end