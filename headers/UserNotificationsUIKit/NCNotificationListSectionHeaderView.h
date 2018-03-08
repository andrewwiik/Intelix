@interface NCNotificationListSectionHeaderView : UICollectionReusableView
@property (nonatomic,retain) UILabel* titleLabel;                                          //@synthesize titleLabel=_titleLabel - In the implementation block
@property (nonatomic,retain) UIButton* clearButton;
@property (assign,nonatomic) BOOL shouldOverrideForReveal;                                             //@synthesize shouldOverrideForReveal=_shouldOverrideForReveal - In the implementation block
@property (assign,nonatomic) CGFloat overrideAlpha;                                                     //@synthesize overrideAlpha=_overrideAlpha - In the implementation block
@property (assign,nonatomic) CGPoint overrideCenter;  
- (void)setTitle:(NSString *)title forSectionIdentifier:(NSString *)sectionIdentifier;
- (void)setBackgroundGroupName:(NSString *)name;  
- (void)_resetRevealOverrides;
@end