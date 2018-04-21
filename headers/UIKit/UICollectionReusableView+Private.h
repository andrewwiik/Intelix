@interface UICollectionReusableView (Private)
@property (nonatomic, retain, getter=_collectionView) UICollectionView *collectionView;
@property (setter=_setLayoutAttributes:,getter=_layoutAttributes,nonatomic,copy) UICollectionViewLayoutAttributes * layoutAttributes;
@end