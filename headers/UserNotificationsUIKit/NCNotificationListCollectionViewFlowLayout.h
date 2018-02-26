@interface NCNotificationListCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,retain) NSMutableArray *insertedIndexPaths;
@property (nonatomic,retain) NSMutableArray *removedIndexPaths;
@property (nonatomic,retain) NSMutableArray *replacedIndexPaths;
@property (assign,getter=isShowingNotificationsHistory,nonatomic) bool showingNotificationsHistory;
@end