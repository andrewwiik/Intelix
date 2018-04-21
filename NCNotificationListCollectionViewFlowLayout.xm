#import <Intelix/ITXNCGroupBackgroundView.h>
#import <UserNotificationsUIKit/NCNotificationListCollectionViewFlowLayout.h>
#import <UIKit/_UIFlowLayoutInfo.h>
#import <UIKit/UICollectionViewLayoutAttributes+Private.h>
#import <Intelix/NCNotificationCombinedListViewController.h>
#import <Intelix/NCNotificationPriorityList.h>

@interface NCNotificationListCollectionViewFlowLayout ()
- (CGRect)itx_frameForSection:(NSInteger)section;
- (NSRange)itx_rangeOfSectionsInRect:(CGRect)rect;
- (NSUInteger)priorityEndSection;
@end

%hook NCNotificationListCollectionViewFlowLayout
- (CGFloat)minimumLineSpacing {
	// HBLogInfo(@"Method #90");
	return 0;
}

// - (CGFloat)minimumInteritemSpacing {
// 	// HBLogInfo(@"Method #91");
// 	return 0;
// }

- (id)_animationForReusableView:(id)view toLayoutAttributes:(id)attributes type:(NSUInteger)type {
	// HBLogInfo(@"Method #92");
	return nil;
}

%new
- (NSUInteger)priorityEndSection {
	// HBLogInfo(@"Method #93");
	return 0;
	NCNotificationCombinedListViewController *controller = (NCNotificationCombinedListViewController *)[self.collectionView valueForKey:@"_delegate"];
	return [controller.notificationPriorityList sectionCount] - 1;
}

%new
- (CGRect)itx_frameForSection:(NSInteger)section {
	// HBLogInfo(@"Method #94");
	_UIFlowLayoutInfo *info = [self valueForKey:@"_data"];
	if (info) {
		if (info.sections && [info.sections objectAtIndex:section]) {
			CGRect frame = ((_UIFlowLayoutSection *)[info.sections objectAtIndex:section]).frame;
			//UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
			//CGFloat originDifference = frame.origin.y - headerAttributes.frame.origin.y;
			frame.size.width -= (8*2);
			frame.origin.x += 8;
			// frame.size.height += 20;
			// frame.origin.y -= 20;
			//frame.origin.y = headerAttributes.frame.origin.y;
			//frame.size.height -= originDifference;
			// HBLogInfo(@"Method #94 Ended");
			return frame;
		}
	}
	// HBLogInfo(@"Method #94 Ended");
	return CGRectZero;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
	// HBLogInfo(@"Method #95");
	NSMutableArray *result = [NSMutableArray new];
 	[result addObjectsFromArray:%orig];


 	const NSRange range = [self itx_rangeOfSectionsInRect:rect];

 	if (range.location == NSNotFound) {
        return result;
    }

 	for (NSInteger section = range.location; section < NSMaxRange(range); section++) {
 		if (section != 0 && [self.collectionView numberOfItemsInSection:section] > 0) {
 			UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:[ITXNCGroupBackgroundView elementKind] atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
 			if (attributes) {
 				[result addObject:attributes];
 			} else {
 				// HBLogInfo(@"Couldn't get backgroud attributes for Section: %@", @(section));
 			}
 		}
 	}

 	// if ([self.collectionView numberOfItemsInSection:0] > 0) {
 	// 	UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
 	// 	[result addObject:attributes];
 	// }


 	return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
	// HBLogInfo(@"Method #96");
	if ([indexPath section] == 0) return %orig;
	if (elementKind && [elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
		if ([indexPath section] == 0) {
			UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
			if (attributes) {
				[attributes setValue:indexPath forKey:@"_indexPath"];
				CGRect frame = attributes.frame;
				frame.origin.y = 0;
				attributes.frame = frame;
				if ([indexPath section] > [self priorityEndSection]) {
					// attributes.alpha = 1.0;
					// attributes.hidden = NO;
				//	attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
					//attributes.hidden = self.showingNotificationsHistory ? NO : YES;
				} else {
					attributes.alpha = 1.0;
					attributes.hidden = NO;
				}
				return attributes;
			}
		} else {
			UICollectionViewLayoutAttributes *attributes = %orig;
			if (attributes) {
				//[attributes setValue:indexPath forKey:@"_indexPath"];
				// CGRect frame = attributes.frame;
				// frame.origin.y = 0;
				// attributes.frame = frame;
				if ([indexPath section] > [self priorityEndSection]) {
					// attributes.alpha = 1.0;
					// attributes.hidden = NO;
					attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
					attributes.hidden = !self.showingNotificationsHistory;
				} else {
					attributes.alpha = 1.0;
					attributes.hidden = NO;
				}
				return attributes;
			}
		}
	} else {
		// if (elementKind && [elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
		// 	UICollectionViewLayoutAttributes *attributes = %orig;
		// 	if (attributes) {
		// 		if ([indexPath section] > [self priorityEndSection]) {
		// 			attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
		// 		} else {
		// 			attributes.alpha = 1.0;
		// 			// attributes.hidden = NO;
		// 		}
		// 		return attributes;
		// 	}
		// }
	}
	if (elementKind && [elementKind isEqualToString:[ITXNCGroupBackgroundView elementKind]]) {
		UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
		// if (!attributes) {
		// 	attributes = %orig;
		// }
		// if (!attributes && [indexPath section] == 0) {
		// 	attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
		// }
		if (!attributes) {
			attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
			if (attributes) {
				[attributes setValue:indexPath forKey:@"_indexPath"];
			}
		}
		if (attributes) {
			[attributes setValue:[ITXNCGroupBackgroundView elementKind] forKey:@"_elementKind"];
			attributes.frame = [self itx_frameForSection:[indexPath section]];
			attributes.zIndex = -99;
			[attributes _setZPosition:-99];
			if ([indexPath section] > [self priorityEndSection]) {
				// attributes.alpha = 1.0;
				// attributes.hidden = NO;
				attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
				attributes.hidden = !self.showingNotificationsHistory;
			} else {
				attributes.alpha = 1.0;
				attributes.hidden = NO;
			}
			// if ([indexPath section] > [self priorityEndSection]) {
			// 	attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
			// } else {
			// 	attributes.alpha = 1.0;
			// 	// attributes.hidden = NO;
			// }
			//attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
			//(UIView *)[collectionView _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[indexPath section]]];
			//UIView header = (UIView *)[self.collectionView _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[indexPath section]]];
			return attributes;
		}
	} else if (elementKind && [elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
		UICollectionViewLayoutAttributes *attributes = %orig;
		if (attributes) {
			if ([indexPath section] > [self priorityEndSection]) {
				attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
			} else {
				attributes.alpha = 1.0;
				attributes.hidden = NO;
			}
			//attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
			// CGRect frame = attributes.frame;
			// frame.origin.x += 8;
			// frame.size.width -= (8*2);
			// attributes.frame = frame;
			return attributes;
		}
	}
	return %orig;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
	// HBLogInfo(@"Method #97");
	if ([itemIndexPath section] == 0) return %orig;
	UICollectionViewLayoutAttributes *attributes = %orig;
	if ([self.insertedIndexPaths containsObject:itemIndexPath]) {
		//attributes.alpha = 2.0;
		//attributes.size = CGSizeMake(attributes.size.width, 0);
		//CGAffineTransform transform = attributes.transform;
		//transform.a = 1.0;
		//if ([itemIndexPath row] > 0) {
			UICollectionViewLayoutAttributes *aboveAttributes = attributes;
			CGRect frame = aboveAttributes.frame;
			frame.origin.y -= 20;
			frame.origin.x = 8;
			// frame.size.height = 0;
			frame.size.width = attributes.size.width;
			attributes.alpha = 0.0;
			attributes.frame = frame;

		//}

		//attributes.alpha = 1.0;
	}
	//attributeS = attributes;
	return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
	// HBLogInfo(@"Method #98");
	if ([itemIndexPath section] == 0) return %orig;
	UICollectionViewLayoutAttributes *attributes = %orig;
	// if ([itemIndexPath row] > 0) {
	// 	UICollectionViewLayoutAttributes *aboveAttributes = %orig([NSIndexPath indexPathForRow:[itemIndexPath row] - 1 inSection:[itemIndexPath section]]);
	// }
	//UICollectionViewLayoutAttributes *aboveAttributes

	if ([self.removedIndexPaths containsObject:itemIndexPath]) {
		//if ([itemIndexPath row] > 0) {
			UICollectionViewLayoutAttributes *aboveAttributes = attributes;
			CGRect frame = aboveAttributes.frame;
			// frame.origin.y += aboveAttributes.size.height;
			frame.origin.x = 8;
			frame.size.height = 0;
			frame.size.width = attributes.size.width ;
			attributes.frame = frame;

		//}
		
		attributes.alpha = 0.0;
	}
	return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForFooterInSection:(NSInteger)section {
	// HBLogInfo(@"Method #99");
	if (section == 0) return %orig;
	UICollectionViewLayoutAttributes *attributes = %orig;
	if (section > [self priorityEndSection]) {
		attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
	} else {
		attributes.alpha = 1.0;
		attributes.hidden = NO;
	}
	//attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
	return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForFooterInSection:(NSInteger)section usingData:(id)data {
	// HBLogInfo(@"Method #100");
	if (section == 0) return %orig;
	UICollectionViewLayoutAttributes *attributes = %orig;
	// attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
	if (section > [self priorityEndSection]) {
		attributes.alpha = self.showingNotificationsHistory ? 1.0 : 0.0;
	} else {
		attributes.alpha = 1.0;
		attributes.hidden = NO;
	}
	return attributes;
}

// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//     if (section == 0 && [self.collectionView numberOfItemsInSection:0] > 0) {
//         return CGSizeMake(0, 60);
//     }
//     return %orig;
// }

// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
// 	if (section >)
//     if (section == 0 && [self.collectionView numberOfItemsInSection:0] > 0) {
//         return CGSizeMake(0, 0);
//     }
//     return %orig;
// }

%new
- (NSRange)itx_rangeOfSectionsInRect:(CGRect)rect {
	// HBLogInfo(@"Method #101");
	NSRange result = NSMakeRange(NSNotFound, 0);
	const NSInteger sectionCount = [self.collectionView numberOfSections];

	for (NSInteger section = 0; section < sectionCount; section++) {
		CGRect sectionFrame = [self itx_frameForSection:section];
		if (!CGSizeEqualToSize(sectionFrame.size, CGSizeZero) && CGRectIntersectsRect(sectionFrame, rect)) {
			const NSRange sectionRange = NSMakeRange(section, 1);
			if (result.location == NSNotFound) {
				result = sectionRange;
			} else {
				result = NSUnionRange(result, sectionRange);
			}
		}
	}
	return result;
}
%end