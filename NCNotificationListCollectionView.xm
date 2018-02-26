// @interface NCNotificationListCollectionView : UICollectionView
// @end

// %hook NCNotificationListCollectionView
// - (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)paths {
// 	NSMutableArray *newPaths = [NSMutableArray new];
// 	for (NSIndexPath *path in paths) {
// 		if ([path row] < [self numberOfItemsInSection:[path section]]) {
// 			[newPaths addObject:path];
// 		}
// 	}
// 	%orig(newPaths);
// }
// %end