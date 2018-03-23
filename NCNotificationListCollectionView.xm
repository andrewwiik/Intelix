@interface NCNotificationListCollectionView : UICollectionView
@end

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

-(void)reloadSections:(NSArray<NSIndexPath *> *)sections {
	[self reloadData];
	return;
} 
%end
