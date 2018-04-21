@class NCNotificationCombinedListViewController;

@interface ITXNCGroupFooterView : UICollectionReusableView
@property (nonatomic, retain, readwrite) UIView *separatorView;
@property (nonatomic, retain, readwrite) UILabel *middleLabel;
@property (nonatomic, assign, readwrite) NSInteger numberToShow;
@property (nonatomic, retain, readwrite) NCNotificationCombinedListViewController *cellDelegate;
@property (nonatomic, retain, readwrite) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, retain, readwrite) NSString *sectionIdentifier;
@property (nonatomic, assign, readwrite) BOOL isExpanded;
- (void)setLabelText:(NSString *)text;
- (void)setupMiddleLabel;
- (void)toggleShowAllNotifications;

// Notification Animation Stuff
@property (assign, nonatomic, readwrite) BOOL shouldOverrideForReveal;                                             //@synthesize shouldOverrideForReveal=_shouldOverrideForReveal - In the implementation block
@property (assign, nonatomic, readwrite) CGFloat overrideAlpha;                                                     //@synthesize overrideAlpha=_overrideAlpha - In the implementation block
@property (assign, nonatomic, readwrite) CGPoint overrideCenter;
- (void)_resetRevealOverrides;  

// ColorBanners
- (void)setTextColor:(UIColor *)color;
@end