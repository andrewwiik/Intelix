@interface NCNotificationListCollectionView : UICollectionView
@end

static BOOL bypassHandler = NO;

%hook NSAssertionHandler
-(void)handleFailureInMethod:(SEL)arg1 object:(id)arg2 file:(id)arg3 lineNumber:(NSInteger)arg4 description:(id)arg5 {
	if (bypassHandler) {
		HBLogInfo(@"Failure With Description: %@", arg5);
		return;
	} else {
		%orig;
	}
}
%end

%hook NCNotificationListCollectionView

-(void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)paths {
	// HBLogInfo(@"Inserting Index Paths");
	[self reloadData];
	return;
	// if (paths) {
	// 	for (NSIndexPath *path in paths) {
	// 		// HBLogInfo(@"Inserting Index Path: %@", path);
	// 	}
	// }
	// %orig;
}

-(void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)paths {
	// HBLogInfo(@"Deleting Index Paths");
	[self reloadData];
	return;
	// if (paths) {
	// 	for (NSIndexPath *path in paths) {
	// 		// HBLogInfo(@"Inserting Index Path: %@", path);
	// 	}
	// }
	// %orig;
}

-(void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)paths {
	// HBLogInfo(@"Reloading Index Paths");
	// if (paths) {
	// 	for (NSIndexPath *path in paths) {
	// 		// HBLogInfo(@"Inserting Index Path: %@", path);
	// 	}
	// }
	[self reloadData];
	return;
	//%orig;
}

- (void)reloadData {
	[self.collectionViewLayout invalidateLayout];
	[self setNeedsLayout];
	%orig;
	//[self setCollectionViewLayout:self.collectionViewLayout animated:false];
	// [self.collectionViewLayout invalidateLayout];
	[self layoutIfNeeded];
	//[self layoutSubviews];
	//[self.collectionViewLayout invalidateLayout];
	// [self layoutIfNeeded]
	// [self.collectionViewLayout prepareLayout];
	// [self setNeedsLayout];
	// [self layoutIfNeeded];
}

- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion {
	if (!updates && !completion) {
		[self reloadData];
		return;
	}

	[self reloadData];
	if (completion) {
		completion(YES);
	}
	return;
}

- (void)layoutSubviews {
	bypassHandler = YES;
	%orig;
	bypassHandler = NO;
}

- (void)moveItemAtIndexPath:(NSIndexPath *)prevPath toIndexPath:(NSIndexPath *)newPath {
	[self reloadData];
	return;
}

-(void)reloadSections:(NSArray<NSIndexPath *> *)sections {
	[self reloadData];
	return;
}

- (void)deleteSections:(NSArray<NSIndexPath *> *)sections {
	[self reloadData];
	return;
}
- (void)insertSections:(NSArray<NSIndexPath *> *)sections {
	[self reloadData];
	return;
}
%end
