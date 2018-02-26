#import "ITXAnimatedCornersView.h"

@interface ITXAnimatedSeperatedCornersView : UIView
@property (nonatomic, assign, readwrite) CGFloat topInset;
@property (nonatomic, assign, readwrite) CGFloat bottomInset;
@property (nonatomic, assign, readwrite) CGFloat topCornerRadius;
@property (nonatomic, assign, readwrite) CGFloat bottomCornerRadius;
@property (nonatomic, retain, readwrite) ITXAnimatedCornersView *topMaskView;
@property (nonatomic, retain, readwrite) ITXAnimatedCornersView *bottomMaskView;
@property (nonatomic, retain, readwrite) UIView *topView;
@property (nonatomic, retain, readwrite) UIView *bottomView;
@property (nonatomic, retain, readwrite) UIView *containerView;
@end