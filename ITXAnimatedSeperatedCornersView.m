#import <Intelix/ITXAnimatedSeperatedCornersView.h>

@implementation ITXAnimatedSeperatedCornersView
- (id)init {
	self = [super init];
	if (self) {
		_topView = [UIView new];
		_topView.backgroundColor = [UIColor blackColor];
		_topView.clipsToBounds = YES;

		_bottomView = [UIView new];
		_bottomView.backgroundColor = [UIColor blackColor];
		_bottomView.clipsToBounds = YES;


		_topMaskView = [[ITXAnimatedCornersView alloc] init];
		_topMaskView.backgroundColor = [UIColor blackColor];
		_topView.maskView = _topMaskView;

		_bottomMaskView = [[ITXAnimatedCornersView alloc] init];
		_bottomMaskView.backgroundColor = [UIColor blackColor];
		_bottomView.maskView = _bottomMaskView;

		_containerView = [[UIView alloc] init];
		//_containerView.backgroundColor = [UIColor blackColor];

		_topCornerRadius = 0;
		_bottomCornerRadius = 0;
		_topInset = 0;
		_bottomInset = 0;

		[_containerView addSubview:_topView];
		[_containerView addSubview:_bottomView];

		self.maskView = _containerView;
		self.backgroundColor = [UIColor redColor];
	}
	return self;
}

- (void)setTopCornerRadius:(CGFloat)cornerRadius {
	//_topMaskView.layer.cornerRadius = cornerRadius;
	_topCornerRadius = cornerRadius;
}
- (void)setBottomCornerRadius:(CGFloat)cornerRadius {
	//_bottomMaskView.layer.cornerRadius = cornerRadius;
	_bottomCornerRadius = cornerRadius;
}

- (void)setTopInset:(CGFloat)inset {
	_topInset = inset;
}

- (void)setBottomInset:(CGFloat)inset {
	_bottomInset = inset;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGFloat halfHeight = self.bounds.size.height/2;
	CGFloat width = self.bounds.size.width;
	CGFloat topRadius = _topCornerRadius;
	CGFloat bottomRadius = _bottomCornerRadius;

	_topView.layer.cornerRadius = _topCornerRadius;
	_bottomView.layer.cornerRadius = _bottomCornerRadius;

	_containerView.frame = self.bounds;
	_topView.frame = CGRectMake(0,0 + _topInset,width,halfHeight + topRadius);
	_bottomView.frame = CGRectMake(0,halfHeight - bottomRadius - _bottomInset,width,halfHeight + bottomRadius);

	_topMaskView.frame = CGRectMake(0,0,width, halfHeight - _topInset);
	_bottomMaskView.frame = CGRectMake(0,0 + bottomRadius + _bottomInset,width, halfHeight - _bottomInset);
}
@end