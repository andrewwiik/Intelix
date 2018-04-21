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
#import <SpringBoard/SBDashBoardNotificationDispatcher.h>
#import <UserNotificationsKit/NCNotificationDispatcher.h>
#import <UserNotificationsUIKit/NCNotificationShortLookViewController.h>

// static BOOL isIOS11 = YES;


static NCNotificationCombinedListViewController *controller;
static BOOL tellTruth = NO;
static NCNotificationDispatcher *cachedDispatcher;

%hook NCNotificationCombinedListViewController

%new
- (NCNotificationDispatcher *)notificationDispatcher {
	if (!cachedDispatcher) {
		if (self.destinationDelegate) {
			if (self.destinationDelegate.dispatcher) {
				SBDashBoardNotificationDispatcher *dashboardDispatcher = self.destinationDelegate.dispatcher;
				NCNotificationDispatcher *dispatcher = (NCNotificationDispatcher *)MSHookIvar<id>(dashboardDispatcher, "_notificationDestinationDelegate");
				if (dispatcher) {
					cachedDispatcher = dispatcher;
				}
			}
		}
	}
	return cachedDispatcher;
}

%new
+ (NCNotificationCombinedListViewController *)sharedController {
	return controller;
}

- (BOOL)_isNotificationRequestForLockScreenNotificationDestination:(NCNotificationRequest *)request {
	return %orig;
	// HBLogInfo(@"Method #25");
	if (tellTruth) return %orig;
	return NO;
	BOOL orig = %orig;
	return orig;
	// return orig;
	if (orig) {
		self.showingNotificationsHistory = YES;
		self.notificationPriorityList.controller = self;
		//[self _revealNotificationsHistory];
	}
	return NO;
	// return NO;
}

%new
- (id)sectionList {
	// HBLogInfo(@"Method #26");
	return [self notificationSectionList];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout referenceSizeForHeaderInSection:(NSUInteger)section {
	// HBLogInfo(@"Method #27");
	if (section == 0) return %orig;
	if (section > [self.notificationPriorityList sectionCount] - 1) return %orig;
	else {
		if ([collectionView numberOfItemsInSection:section] > 0) {
			return CGSizeMake(collectionView.bounds.size.width, 60);
		} else {
			return CGSizeZero;
		}
	}
}


%new
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	if (section == 0) return 10;
   	else return 0;
}

// - (CGSize)collectionView:(UICollectionView *)collectiobView layout:(UICollectionView *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
// 	CGSize orig = %orig;
// 	if ([indexPath section] == 0) {
// 		orig.height += 32;
// 	}
// 	return orig;
// }

%new
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
   	if (section == 0) return 10;
   	else return 0;
    //return 10; // This is the minimum inter item spacing, can be more
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(NCNotificationListCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath  {
	if ([indexPath section] == 0) return %orig;
	if ([cell isKindOfClass:NSClassFromString(@"NCNotificationListCell")]) {
		cell.hasFooterUnder = [self.sectionList sectionHasFooter:[self _adjustedSectionIndexForListOperation:[indexPath section]]];
		cell.isLastInSection = [self collectionView:collectionView numberOfItemsInSection:[indexPath section]] - 1 == [indexPath row];
		cell._isFirstInSection = [indexPath row] == 0;
		if ([indexPath section] > [self.notificationPriorityList sectionCount] - 1) {
			cell.hidden = !self.showingNotificationsHistory;
		} else {
			cell.hidden = NO;
			cell.alpha= 1.0;
		}
		//cell.hasFooterUnder = [self.sectionList sectionIsCollapsed:[indexPath section]];
		// cell.cellOver = nil;
		// cell.cellUnder = nil;
	}
	%orig;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath  {
	if ([indexPath section] == 0) return %orig;
	if (kind && [kind isEqualToString:[ITXNCGroupBackgroundView elementKind]]) {
		ITXNCGroupBackgroundView *bgView = (ITXNCGroupBackgroundView *)view;
		if ([indexPath section] > [self.notificationPriorityList sectionCount] - 1) {
			bgView.hidden = !self.showingNotificationsHistory;
			bgView.isTopSection = NO;
			if (!self.showingNotificationsHistory) {
				bgView.alpha = 0;
			}
		} else {
			[bgView _resetRevealOverrides];
			bgView.isTopSection = YES;
			view.alpha= 1.0;
			view.hidden = NO;
		}
		// if ([indexPath section] == 0) {
		// 	[bgView _resetRevealOverrides];
		// 	view.alpha = 1.0;
		// 	view.hidden = NO;
		// }
	} else if (kind && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
		NCNotificationListSectionHeaderView *headerView = (NCNotificationListSectionHeaderView *)view;
		if ([indexPath section] > [self.notificationPriorityList sectionCount] - 1) {
			headerView.hidden = !self.showingNotificationsHistory;
			headerView.isTopSection = NO;
			if (!self.showingNotificationsHistory) {
				headerView.overrideAlpha = 0;
				headerView.alpha = 0;
			}
		} else {
			headerView.isTopSection = YES;
			headerView.alpha = 1.0;
			headerView.hidden = NO;
		}
	}
	%orig;
}


-(id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
	// HBLogInfo(@"Method #27");
	// NSUInteger section = [indexPath section];
	// if (section > [self.notificationPriorityList sectionCount] - 1) {
	// 	if ([self.sectionList sectionIsCollapsed:[self _adjustedSectionIndexForListOperation:[indexPath section]]]) {
	// 		if ([indexPath row] > 2) return nil;
	// 	}
	// } else {

	// }
	if ([indexPath section] == 0) return %orig;
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
			cell.alpha = 1.0;
			// cell.alpha = 1.0;
		}
		//cell.hasFooterUnder = [self.sectionList sectionIsCollapsed:[indexPath section]];
		// cell.cellOver = nil;
		// cell.cellUnder = nil;
	}
	return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(NCNotificationListCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath  {
	// HBLogInfo(@"Method #28");
	if ([indexPath section] == 0) return %orig;
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

%new
- (void)clearNotificationsInSection:(NSUInteger)section {
	if (section < [self.notificationPriorityList sectionCount]) {
		return [self.notificationPriorityList clearNotificationsInSection:section];
	} else {
		return [self.sectionList clearNotificationsInSection:[self _adjustedSectionIndexForListOperation:section]];
	}
}

-(UIView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	// return %orig;
	// HBLogInfo(@"Method #29");
	if ([indexPath section] == 0) return %orig;

	if (kind && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
		if ([self.collectionView numberOfItemsInSection:[indexPath section]] > 0) {
			NCNotificationListSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"NotificationListSectionHeaderReuseIdentifier" forIndexPath:indexPath];
			headerView.delegate = self;
			if ([indexPath section] > [self.notificationPriorityList sectionCount] - 1) {
				headerView.overrideAlpha = self.showingNotificationsHistory ? 1.0 : 0.0;
				headerView.isTopSection = NO;
				//if (self.showingNotificationsHistory) headerView.backgroundColor = [UIColor redColor];
				//else headerView.backgroundColor = [UIColor greenColor];
				if (!self.showingNotificationsHistory) headerView.alpha = 0;
				headerView.hidden = !self.showingNotificationsHistory;
				[headerView setTitle:[self.sectionList titleForSectionIndex:[self _adjustedSectionIndexForListOperation:[indexPath section]]] forSectionIdentifier:[self.sectionList identifierForSectionIndex:[self _adjustedSectionIndexForListOperation:[indexPath section]]]];
			} else {
				//headerView.backgroundColor = [UIColor blueColor];
				headerView.overrideAlpha = 1.0;
				headerView.alpha = 1.0;
				headerView.hidden = NO;
				headerView.isTopSection = YES;
				[headerView setTitle:[self.notificationPriorityList titleForSectionIndex:[indexPath section]] forSectionIdentifier:[self.notificationPriorityList identifierForSectionIndex:[indexPath section]]];
				// [headerView setTitle:]
			}

			headerView.indexPath = indexPath;
			return headerView;
		}
	}
	if (kind && [kind isEqualToString:[ITXNCGroupBackgroundView elementKind]]) {
		ITXNCGroupBackgroundView *backgroundView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ITXNCGroupBackgroundViewReuseIdentifier" forIndexPath:indexPath];
		backgroundView.isSectionBackground = YES;
		if ([indexPath section] > [self.notificationPriorityList sectionCount] - 1) {
			backgroundView.isTopSection = NO;
		} else {
			backgroundView.isTopSection = YES;
		}
		// if ([indexPath section] > [self.notificationPriorityList sectionCount] - 1) {
		// 	[bgView _resetRevealOverrides];
		// 	view.alpha = 1.0;
		// 	view.hidden = NO;

		// } else {
		// 	if (!self.showingNotificationsHistory) {
		// 		bgView.alpha = 0;
		// 	}
		// }
		return backgroundView;
	}

	//if (isIOS11 && [indexPath section] < 1) return %orig;

	if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
		if ([indexPath section] > [self.notificationPriorityList sectionCount] - 1) {
			if ([self.sectionList sectionHasFooter:[self _adjustedSectionIndexForListOperation:[indexPath section]]]) {
				ITXNCGroupFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NotificationListSectionHFooterReuseIdentifier" forIndexPath:indexPath];
				footerView.numberToShow = [self.sectionList actualNumberOfNotificationsInSection:[self _adjustedSectionIndexForListOperation:[indexPath section]]] - 3;
				footerView.cellDelegate = self;
				footerView.sectionIdentifier = [self.sectionList otherSectionIdentifierForSectionIndex:[self _adjustedSectionIndexForListOperation:[indexPath section]]];
				footerView.isExpanded = [self.sectionList sectionIsExpanded:[self _adjustedSectionIndexForListOperation:[indexPath section]]];
				footerView.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
				footerView.userInteractionEnabled = YES;
				return footerView;
			}
		} else {
			ITXNCGroupFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NotificationListSectionHFooterReuseIdentifier" forIndexPath:indexPath];
			//footerView.numberToShow =
			footerView.userInteractionEnabled = NO;
			return footerView;
		}
	}
	return nil;

	// return %orig;
	// return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	// HBLogInfo(@"Method #30");
	if (section == 0) return %orig;
	if (section > [self.notificationPriorityList sectionCount] - 1) {
		if ([self.sectionList sectionHasFooter:[self _adjustedSectionIndexForListOperation:section]]) {
			return CGSizeMake(collectionView.frame.size.width - 8*2, 36);
		}
	} 
	return CGSizeZero;
}

- (void)viewDidLoad {
	// HBLogInfo(@"Method #31");
	controller = self;
	%orig;
	if (self.notificationPriorityList) self.notificationPriorityList.controller = self;
	[[self collectionView] registerClass:[ITXNCGroupFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NotificationListSectionHFooterReuseIdentifier"];
	[[self collectionView] registerClass:[ITXNCGroupBackgroundView class] forSupplementaryViewOfKind:[ITXNCGroupBackgroundView elementKind] withReuseIdentifier:@"ITXNCGroupBackgroundViewReuseIdentifier"];
}

%new
-(void)sectionFooterView:(ITXNCGroupFooterView *)footerView didReceiveToggleExpansionActionForSectionIdentifier:(NSString *)sectionIdentifier {
	// HBLogInfo(@"Method #32");
	[self.sectionList toggleExpansionForSectionIdentifier:sectionIdentifier];
}

- (BOOL)dismissNotificationInLongLookAnimated:(BOOL)animated {
	return %orig(NO);
}

- (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didInsertNotificationRequest:(NCNotificationRequest *)request atIndexPath:(NSIndexPath *)path {
	if (request) {
		[self _removeCachedSizesForNotificationRequest:request];
	}
	%orig;
	return;
	// HBLogInfo(@"Method #33");
	// [self _performCollectionViewOperationBlockIfNecessary:^{
	// 	[[[self collectionView] collectionViewLayout] invalidateLayout];
	// 	NSUInteger section = [path section];
	// 	//if (section > 0) {
	// 	if ([self.sectionList sectionIsCollapsed:section]) {
	// 		[[self collectionView] reloadSections:[NSIndexSet indexSetWithIndex:[self _adjustedSectionIndexForCollectionViewOperation:section]]];
	// 	} else {
	// 		NSIndexPath *newPath = [NSIndexPath indexPathForRow:[path row] inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]];
	// 		[[self collectionView] insertItemsAtIndexPaths:[NSArray arrayWithObjects:newPath,nil]];
	// 	}

	// 	if ([self.sectionList sectionIsCollapsed:section]) {
	// 		ITXNCGroupFooterView *footerView = (ITXNCGroupFooterView *)[[self collectionView] _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
	// 		if (footerView) {
	// 			footerView.numberToShow = [self.sectionList actualNumberOfNotificationsInSection:[path section]] - 3;
	// 			footerView.cellDelegate = self;
	// 			footerView.sectionIdentifier = [self.sectionList otherSectionIdentifierForSectionIndex:[path section]];
	// 			footerView.isExpanded = [self.sectionList sectionIsExpanded:[path section]];

	// 			// if (![self.sectionList sectionIsCollapsed:section]) {
	// 			// 	[self.collectionView.collectionViewLayout invalidateLayout];
	// 			// }
	// 		}
	// 	}
	// 	//}
	// }];
	self.notificationHistorySectionNeedsReload = YES;
	[self _reloadNotificationHistorySectionIfNecessary];
	//[self.collectionView reloadData];
}

- (void)notificationSectionList:(id)list didRemoveSectionAtIndex:(NSUInteger)sectionIndex {
	%orig;
	return;
	if (list && [list isKindOfClass:NSClassFromString(@"NCNotificationChronologicalList")]) {
		sectionIndex = [self _adjustedSectionIndexForCollectionViewOperation:sectionIndex];
	}
	[self _performCollectionViewOperationBlockIfNecessary:^{
		[[[self collectionView] collectionViewLayout] invalidateLayout];
		[[self collectionView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
	}];
}

- (void)notificationSectionList:(id)list didInsertSectionAtIndex:(NSUInteger)sectionIndex {
	%orig;
	return;
	if (list && [list isKindOfClass:NSClassFromString(@"NCNotificationChronologicalList")]) {
		sectionIndex = [self _adjustedSectionIndexForCollectionViewOperation:sectionIndex];
	}
	[self _performCollectionViewOperationBlockIfNecessary:^{
		[[[self collectionView] collectionViewLayout] invalidateLayout];
		[[self collectionView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
	}];
}

// - (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didRemoveNotificationRequest:(NCNotificationRequest *)request atIndexPath:(NSIndexPath *)path {
// 	%orig;
// 	return;
// 	// HBLogInfo(@"Method #34");
// 	// HBLogInfo(@"Removed Notification: %@\n IndexPath: %@", request, path);
// 	// NCNotificationListCell *cell = (NCNotificationListCell *)[[self collectionView] _visibleCellForIndexPath:[self _adjustedSectionIndexPathForCollectionViewOperation:path]];
// 	// NSLog(@"NOTIFICATION REMOVAL:\n CELL: %@\nPATH: %@\n,ADJUSTED PATH: %@", cell, path, [self _adjustedSectionIndexPathForCollectionViewOperation:path]);

// 	// if (cell) {
// 	// 	NSLog(@"NOTIFICATION REMOVAL:\n CELL: %@\nPATH: %@\n,ADJUSTED PATH: %@\nCELL OVER: %@\nCELL UNDER: %@", cell, path, [self _adjustedSectionIndexPathForCollectionViewOperation:path], cell.cellOver, cell.cellUnder);
// 	// 	if (cell.cellOver && [cell.cellOver respondsToSelector:@selector(itxBackgroundView)]) {
// 	// 		[((id<ITXHasRoundedBackground>)cell.cellOver).itxBackgroundView setBottomRadius:0];
// 	// 		[((id<ITXHasRoundedBackground>)cell.cellOver).itxBackgroundView setBottomClipPercent:0];
// 	// 		NSLog(@"ITX BACKGROUND OVER: %@", ((id<ITXHasRoundedBackground>)cell.cellOver).itxBackgroundView);
// 	// 	}

// 	// 	if (cell.cellUnder && [cell.cellUnder respondsToSelector:@selector(itxBackgroundView)]) {
// 	// 		[((id<ITXHasRoundedBackground>)cell.cellUnder).itxBackgroundView setTopRadius:0];
// 	// 		[((id<ITXHasRoundedBackground>)cell.cellUnder).itxBackgroundView setTopClipPercent:0];
// 	// 		NSLog(@"ITX BACKGROUND UNDER: %@", ((id<ITXHasRoundedBackground>)cell.cellUnder).itxBackgroundView);
		
// 	// 	}

// 	// 	cell.cellOver = nil;
// 	// 	cell.cellUnder = nil;
// 	// }



// //5	[[[self collectionView] collectionViewLayout] invalidateLayout];
// 	//[[[self collectionView] collectionViewLayout] invalidateLayout];
// 	[self _performCollectionViewOperationBlockIfNecessary:^{
// 		BOOL hadFooter = NO;
// 		ITXNCGroupFooterView *footer = (ITXNCGroupFooterView *)[[self collectionView] _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
// 		if (footer) {
// 			hadFooter = !footer.isExpanded;
// 		}
// 		[[[self collectionView] collectionViewLayout] invalidateLayout];
// 		//[[[self collectionView] collectionViewLayout] invalidateLayout];
// 		NSUInteger section = [path section];

// 		if ([self.sectionList sectionIsCollapsed:section] || (hadFooter && ![self.sectionList sectionHasFooter:section])) {
// 			NSMutableArray *indexPaths = [NSMutableArray new];

// 			for (int x = [path row]; x < [self.sectionList rowCountForSectionIndex:section]; x++) {
// 				[indexPaths addObject:[NSIndexPath indexPathForRow:x inSection:[self _adjustedSectionIndexForCollectionViewOperation:section]]];
// 			}

// 			if ([indexPaths count] > 0) {
// 				// HBLogInfo(@"Reloading Items: %@", indexPaths);
// 				// HBLogInfo(@"Nubmer of Items In Section Before Reload: %@", @([self.collectionView numberOfItemsInSection:[self _adjustedSectionIndexForCollectionViewOperation:section]]));
// 				[[self collectionView] reloadItemsAtIndexPaths:[indexPaths copy]];
// 			} else {

// 				// NSLog(@"PATH TO BE RELOADED: %@", path);
// 				// if ([self.sectionList rowCountForSectionIndex:section] >= [path row] + 1) {
// 				// 	[[self collectionView] reloadItemsAtIndexPaths:@[[self _adjustedSectionIndexPathForCollectionViewOperation:path]]];
// 				// }
// 			}
// 		} else {
// 			// HBLogInfo(@"Deleting Items: %@", @[[self _adjustedSectionIndexPathForCollectionViewOperation:path]]);
// 			//NSIndexPath *newPath = [NSIndexPath indexPathForRow:[path row] inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]];
// 			[[self collectionView] deleteItemsAtIndexPaths:@[[self _adjustedSectionIndexPathForCollectionViewOperation:path]]];
// 			// if ([path row] > 0) {
// 			// 	[[self collectionView] reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[path row] - 1 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]],nil]];
// 			// }
// 			// if ([path row] + 1 < [self.sectionList rowCountForSectionIndex:section]) {
// 			// 	[[self collectionView] reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[path row] + 1 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]],nil]];
// 			// }
// 		}

// 		//if ([self.sectionList otherSectionIdentifierForSectionIndex:section] == request.sectionIdentifier) {
// 			ITXNCGroupFooterView *footerView = (ITXNCGroupFooterView *)[[self collectionView] _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
// 			if (footerView) {
// 				footerView.numberToShow = [self.sectionList actualNumberOfNotificationsInSection:[path section]] - 3;
// 				footerView.cellDelegate = self;
// 				footerView.sectionIdentifier = [self.sectionList otherSectionIdentifierForSectionIndex:[path section]];
// 				footerView.isExpanded = [self.sectionList sectionIsExpanded:[path section]];
				
// 				//NCNotificationListCell *lastCell = (NCNotificationListCell *)[[self collectionView] _visibleCellForIndexPath:[NSIndexPath indexPathForRow:[self.sectionList rowCountForSectionIndex:section] - 1 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
// 				// if (lastCell && [lastCell respondsToSelector:@selector(itxBackgroundView)]) {
// 				// 	[lastCell.itxBackgroundView setTopRadius:0 bottomRadius:0 withDelay:0];
// 				// 	lastCell.itxBackgroundView.topClipPercent = 0;
// 				// 	lastCell.itxBackgroundView.bottomClipPercent = 0;
// 				// }
// 				// if ([self.sectionList actualNumberOfNotificationsInSection:section] < 4) {
// 				// 	[self.collectionView.collectionViewLayout invalidateLayout];
// 				// 	[self.collectionView setCollectionViewLayout:self.collectionView.collectionViewLayout];
// 				// }
// 			} else {
// 				// NCNotificationListCell *lastCell = (NCNotificationListCell *)[[self collectionView] _visibleCellForIndexPath:[NSIndexPath indexPathForRow:[self.sectionList rowCountForSectionIndex:section] - 1 inSection:[self _adjustedSectionIndexForCollectionViewOperation:[path section]]]];
// 				// if (lastCell && [lastCell respondsToSelector:@selector(itxBackgroundView)]) {
// 				// 	[lastCell.itxBackgroundView setTopRadius:0 bottomRadius:1 withDelay:0];
// 				// 	lastCell.itxBackgroundView.topClipPercent = 0;
// 				// 	lastCell.itxBackgroundView.bottomClipPercent = 0;
// 				// }
// 			}
// 		//}
// 	}];
// }

%new
- (void)notificationSectionList:(NCNotificationChronologicalList *)sectionList didInsertNotificationRequests:(NSArray<NCNotificationRequest *> *)requests atIndexPaths:(NSArray<NSIndexPath *> *)paths reloadIndexPaths:(NSArray<NSIndexPath *> *)reloadPaths {
	// HBLogInfo(@"Method #35");
	[self.collectionView reloadData];
	return;
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
	// HBLogInfo(@"Method #35");
	[self.collectionView reloadData];
	return;
	[self _performCollectionViewOperationBlockIfNecessary:^{
		NSMutableArray *modifiedPaths = [NSMutableArray new];
		for (NSIndexPath *path in paths) {
			[modifiedPaths addObject:[self _adjustedSectionIndexPathForCollectionViewOperation:path]];
		}
		// HBLogInfo(@"Deleting Items A: %@", modifiedPaths);
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
	// HBLogInfo(@"Method #36");
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

// - (BOOL)removeNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
// 	// HBLogInfo(@"Method #37");
// 	// HBLogInfo(@"Removing Request: %@", request);
// 	if (request && [self.notificationPriorityList containsNotificationRequest:request]) {
// 		// HBLogInfo(@"Removing Priority Notification");
// 		NSIndexPath *path = [self.notificationPriorityList itx_removeNotificationRequest:request];
// 		if (path) {
// 			[[[self collectionView] collectionViewLayout] invalidateLayout];
// 			[self.collectionView reloadData];
// 			[self _updatePrioritySectionLowestPosition];
// 			[self.collectionView layoutSubviews];
// 			return YES;
// 		}  else {
// 			return NO;
// 		}
// 	}
// 	return %orig;
// }



// - (BOOL)modifyNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
// 	// HBLogInfo(@"Method #38");
// 	if ([self.notificationPriorityList containsNotificationRequest:request]) {
// 		NSIndexPath *path = [self.notificationPriorityList itx_modifyNotificationRequest:request];
// 		if (path) {
// 			[[[self collectionView] collectionViewLayout] invalidateLayout];
// 			[self.collectionView reloadData];
// 			[self _updatePrioritySectionLowestPosition];
// 			[self.collectionView layoutSubviews];
// 			return YES;
// 		}  else {
// 			return NO;
// 		}
// 	} else {
// 		return %orig;
// 	}
// }


- (void)insertNotificationRequestIntoRecentsSection:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
	if ([self _isNotificationRequestForLockScreenNotificationDestination:request]) {
		NSMutableSet *requestDestinations = [request.requestDestinations mutableCopy];
		[requestDestinations removeObject:@"BulletinDestinationLockScreen"];
		[requestDestinations removeObject:@"BulletinDestinationBanner"];
		MSHookIvar<NSSet *>(request, "_requestDestinations") = [requestDestinations copy];
		NCNotificationDispatcher *dispatcher = [self notificationDispatcher];
		if (dispatcher) {
			[dispatcher modifyNotificationWithRequest:request];
			//[dispatcher destination:nil requestsClearingNotificationRequests:[NSSet setWithObjects:request, nil]  fromDestinations:[NSSet setWithObjects:@"BulletinDestinationLockScreen", @"BulletinDestinationBanner", nil]];
		}
	}
	[self _removeCachedSizesForNotificationRequest:request];
	%orig;
}

-(void)_moveNotificationRequestsToHistorySectionPassingTest:(/*^block*/id)arg1 animated:(BOOL)arg2 movedAll:(BOOL)arg3 {
	// arg2 = YES;
	arg3 = YES;
	%orig;
}

// - (BOOL)_isNotificationRequestForNotificationCenterDestination:(NCNotificationRequest *)request {
// 	return YES;
// }

%new
- (BOOL)shouldBelongOnLockscreen:(NCNotificationRequest *)request {
	if ([request.requestDestinations containsObject:@"NCBulletinDestinationLockScreen"]) return YES;
	else return NO;
}

- (BOOL)insertNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
	//BOOL hasContent = [self hasContent];
	// HBLogInfo(@"Method #39");
	[self _removeCachedSizesForNotificationRequest:request];
	return %orig;
	// return;

	tellTruth = YES;
	if ([self _isNotificationRequestForLockScreenNotificationDestination:request]) {
		tellTruth = NO;
		[self _resetNotificationsHistory];
		//if (!self.showingNotificationsHistory) {
			// [self _setShowingNotificationsHistory:TRUE animated:false];
			// self.showingNotificationsHistory = YES;
			[self forceNotificationHistoryRevealed:TRUE animated:NO];
		//}
		[self notifyContentObservers];
		// [self _updateRaiseToListenRequest];
		// [[[self collectionView] collectionViewLayout] invalidateLayout];
		//[self.collectionView reloadData];
		// [self _updatePrioritySectionLowestPosition];
		// [self.collectionView layoutSubviews];
	}
	tellTruth = NO;

	// if ([self.notificationPriorityList containsNotificationRequestMatchingRequest:request]) {
	// 	BOOL result = [self modifyNotificationRequest:request forCoalescedNotification:arg2];
	// 	if (result) {
	// 		//if (!hasContent) {
	// 			[self notifyContentObservers];
	// 		//}
	// 	}
	// 	return result;
	// } else {
	// 	BOOL isForLockScreen = [self _isNotificationRequestForLockScreenNotificationDestination:request];
	// 	if (isForLockScreen) {
	// 		BOOL sectionListContainsNotification = [self.sectionList containsNotificationRequest:request];
	// 		if (sectionListContainsNotification) {
	// 			[self.sectionList removeNotificationRequest:request];
	// 		}

	// 		if ([self.notificationPriorityList count] < 1) {
	// 			[self _createRequestOperationAnimationCoordinatorForInitialContentPresentation:YES];
	// 		}

	// 		NSIndexPath *insertedPath = [self.notificationPriorityList itx_insertNotificationRequest:request];
	// 		if (insertedPath) {
	// 			BOOL isFirst = NO;
	// 			if ([insertedPath section] == 0 && [insertedPath row] == 0) {
	// 				isFirst = YES;
	// 			}
	// 			if (isFirst) {
	// 				[self _updateRaiseToListenRequest];
	// 			}
	// 			[[[self collectionView] collectionViewLayout] invalidateLayout];
	// 			[self.collectionView reloadData];
	// 			[self _updatePrioritySectionLowestPosition];
	// 			[self.collectionView layoutSubviews];
	// 		}
	// 	}
	// }
	return %orig;
}

- (NSUInteger)_adjustedSectionIndexForListOperation:(NSUInteger)sectionIndex {
	// HBLogInfo(@"Method #40");
	return %orig;
	sectionIndex -= [self.notificationPriorityList sectionCount];
	return sectionIndex;
}

- (NSUInteger)_adjustedSectionIndexForCollectionViewOperation:(NSUInteger)sectionIndex {
	// HBLogInfo(@"Method #41");
	return %orig;
	sectionIndex += [self.notificationPriorityList sectionCount];
	return sectionIndex;
}	

- (NCNotificationRequest *)notificationRequestAtIndexPath:(NSIndexPath *)indexPath {
	return %orig;
	// HBLogInfo(@"Method #42");
	if ([indexPath section] < [self.notificationPriorityList sectionCount]) {
		return [self.notificationPriorityList notificationRequestAtIndexPath:indexPath];
	} else {
		return [self.sectionList notificationRequestAtIndexPath:[self _adjustedSectionIndexPathForListOperation:indexPath]];
	}
}

- (NSUInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return %orig;
	// HBLogInfo(@"Method #43");
	NSUInteger priorityCount = [self.notificationPriorityList sectionCount];
	NSUInteger historyCount = [self.sectionList sectionCount];
	return priorityCount + historyCount;
}

- (NSUInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section {
	return %orig;
	// HBLogInfo(@"Method #44");
	if (section < [self.notificationPriorityList sectionCount]) {
		return [self.notificationPriorityList rowCountForSectionIndex:section];
	} else {
		return [self.sectionList rowCountForSectionIndex:[self _adjustedSectionIndexForListOperation:section]];
	}
}

- (NSIndexPath *)indexPathForNotificationRequest:(NCNotificationRequest *)request {
	return %orig;
	// HBLogInfo(@"Method #45");
	NSIndexPath *priorityPath = [self.notificationPriorityList indexPathForNotificationRequest:request];
	if (priorityPath != nil) {
		return priorityPath;
	} else {
		return %orig;
	}
}

- (NSMutableArray<NSIndexPath *> *)_filteredIndexPathsForAnimationFromIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
	// HBLogInfo(@"Method #46");
	return %orig;
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
	// HBLogInfo(@"Method #47");
	if (self.notificationPriorityList) {
		self.notificationPriorityList.controller = self;
	}
	%orig;
	// if (self.collectionView) {
	// 	[[[self collectionView] collectionViewLayout] invalidateLayout];
	// 	[self.collectionView reloadData];
	// 	//[self.collectionView layoutSubviews];
	// 	[self _resetNotificationsHistory];
	// 	[self forceNotificationHistoryRevealed:TRUE animated:NO];
	// }
}

%new
- (void)clearNotificationRequests:(NSArray *)requests {
	if ([requests count] > 0) {
		for (NCNotificationRequest *request in requests) {
			[self _removeCachedSizesForNotificationRequest:request];
		}

		NCNotificationDispatcher *dispatcher = [self notificationDispatcher];
		if (dispatcher) {
			[dispatcher destination:nil requestsClearingNotificationRequests:[NSSet setWithArray:requests]];
		}
	}

	// 	if ([self _isNotificationRequestForLockScreenNotificationDestination:request]) {
	// 	NSMutableSet *requestDestinations = [request.requestDestinations mutableCopy];
	// 	[requestDestinations removeObject:@"BulletinDestinationLockScreen"];
	// 	[requestDestinations removeObject:@"BulletinDestinationBanner"];
	// 	MSHookIvar<NSSet *>(request, "_requestDestinations") = [requestDestinations copy];
	// 	NCNotificationDispatcher *dispatcher = [self notificationDispatcher];
	// 	if (dispatcher) {
	// 		[dispatcher modifyNotificationWithRequest:request];
	// 		//[dispatcher destination:nil requestsClearingNotificationRequests:[NSSet setWithObjects:request, nil]  fromDestinations:[NSSet setWithObjects:@"BulletinDestinationLockScreen", @"BulletinDestinationBanner", nil]];
	// 	}
	// }
	// [self _removeCachedSizesForNotificationRequest:request];
	// 	[self.destinationDelegate notificationListViewController:self requestsClearingNotificationRequests:[NSSet setWithArray:requests]];
	// }
}

- (void)_updatePrioritySectionLowestPosition {
	return %orig;
	HBLogInfo(@"Method #48");
	// NSInteger priorityHighestSection = [self.notificationPriorityList sectionCount] - 1;
	// if ([self.collectionView numberOfItemsInSection:priorityHighestSection] > 0) {
	// 	UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:[ITXNCGroupBackgroundView elementKind] atIndexPath:[NSIndexPath indexPathForRow:0 inSection:priorityHighestSection]];
	// 	if (attributes) {
	// 		self.prioritySectionLowestPosition = attributes.frame.origin.y + attributes.frame.size.height;
	// 	}
	// } else {
	// 	self.prioritySectionLowestPosition
	// }
}

- (BOOL)dismissModalFullScreenAnimated:(BOOL)animated {
	NCNotificationViewController *viewController = [self viewControllerPresentingLongLook];
	if (viewController) {
		// if (viewController.view) {
		// 	viewController.view.userInteractionEnabled = NO;
		// }
		if (self.view) {
			self.view.userInteractionEnabled = NO;
		}
		return [viewController dismissPresentedViewControllerAndClearNotification:NO animated:NO completion:^() {
			NCNotificationCombinedListViewController *listController = [NSClassFromString(@"NCNotificationCombinedListViewController") sharedController];
			if (listController) {
				if (listController.view) {
					listController.view.userInteractionEnabled = YES;
				}
			}
		}];
	} else return NO;
}

- (BOOL)notificationViewController:(NCNotificationShortLookViewController *)viewController shouldFinishLongLookTransitionWithCompletionBlock:(id)block {
	UIViewController *longLookController = [viewController _presentedLongLookViewController];
	if (!longLookController) {
		if ([viewController _previewInteractionManager]) {
			NCNotificationPreviewInteractionManager *interactionManager = [viewController _previewInteractionManager];
			if (interactionManager) {
				UIPreviewInteraction *interaction = MSHookIvar<UIPreviewInteraction *>(interactionManager, "_previewInteraction");
				if (interaction) {
					[interaction cancelInteraction];
				}
			}
		}
		return NO;
	}
	else return %orig;
}
%end

@interface BBObserver : NSObject
@end

%hook BBObserver
%new
- (id)remainingFeeds {
	return MSHookIvar<id>(self, "_remainingFeedsByBulletinID");
}
%end