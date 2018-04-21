#import "ITXAnimatedSeperatedCornersView.h"
#import "ITXNCGroupBackgroundConfiguration.h"
#import <MaterialKit/MTMaterialView.h>

@interface ITXNCGroupBackgroundView : UICollectionReusableView {
	CGRect _previousFrame;
	CGRect _previousMiddleFrame;
	id _coloringInfo;
}
@property (nonatomic, assign, readwrite) CGRect middleFrame;
@property (nonatomic, assign, readwrite) CGRect forcedFrame;
@property (nonatomic, retain, readwrite) ITXAnimatedSeperatedCornersView *topView;
@property (nonatomic, retain, readwrite) ITXAnimatedSeperatedCornersView *bottomView;
@property (nonatomic, retain, readwrite) MTMaterialView *backdropView;
@property (nonatomic, retain, readwrite) UIView *containerView;
@property (nonatomic, retain, readwrite) ITXNCGroupBackgroundConfiguration *configuration;
@property (nonatomic, assign, readwrite) BOOL isSectionBackground;
@property (nonatomic, assign, readwrite) BOOL isTopSection;
+ (NSString *)elementKind;

// Notification Animation Stuff :/

@property (assign, nonatomic, readwrite) BOOL shouldOverrideForReveal;                                             //@synthesize shouldOverrideForReveal=_shouldOverrideForReveal - In the implementation block
@property (assign, nonatomic, readwrite) CGFloat overrideAlpha;                                                     //@synthesize overrideAlpha=_overrideAlpha - In the implementation block
@property (assign, nonatomic, readwrite) CGPoint overrideCenter;
- (void)_resetRevealOverrides;  

- (void)doConfigUpdate;

- (void)cbr_setColoringInfo:(id)info;
- (id)cbr_coloringInfo;
@end