#import <Intelix/ITXNCGroupBackgroundView.h>

static CGFloat headerHeight = 20;

@implementation ITXNCGroupBackgroundView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_topView = [[ITXAnimatedSeperatedCornersView alloc] init];
		_bottomView = [[ITXAnimatedSeperatedCornersView alloc] init];

		_containerView = [[UIView alloc] init];
		[_containerView addSubview:_topView];
		[_containerView addSubview:_bottomView];

		_backdropView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipe:1 options:2];
		_backdropView.maskView = _containerView;
		_backdropView.groupName = @"NCNotificationListCombinedListViewController.blur";
		// _backdropView.allowsInPlaceFiltering = YES;
		// _backdropView.backgroundColor = [UIColor redColor];
		[self addSubview:_backdropView];

		_middleFrame = CGRectNull;
		_forcedFrame = self.frame;

		_configuration = [ITXNCGroupBackgroundConfiguration defaultConfiguration];
		[self _resetRevealOverrides];
	}
	return self;
}

- (void)setMiddleFrame:(CGRect)frame {
	if (!CGRectEqualToRect(frame, _middleFrame)) {
		_middleFrame = frame;
		[self layoutSubviews];
	}
}

- (void)setForcedFrame:(CGRect)frame {
	if (!CGRectEqualToRect(frame, _forcedFrame)) {
		_forcedFrame = frame;
		[self layoutSubviews];
	}
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self layoutSubviews];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	//_isSectionBackground = NO;
	// Andy Remove this after testing
	//_forcedFrame = self.frame;
	// if (!CGRectIsNull(_forcedFrame))
	//CGRect forcedFrame = _forcedFrame;
	//self.frame = _forcedFrame;

	CGRect bounds = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height);
	_backdropView.frame = bounds;
	_containerView.frame = bounds;

	ITXNCGroupBackgroundConfiguration *config = _configuration;

	_topView.topCornerRadius = config.topRadius;
	_topView.bottomCornerRadius = config.middleTopRadius;
	_topView.bottomInset = config.middleTopInset;

	_bottomView.topCornerRadius = config.middleBottomRadius;
	_bottomView.bottomCornerRadius = config.bottomRadius;
	_bottomView.topInset = config.middleBottomInset;

	CGRect middleFrame = _middleFrame;
	if (CGRectIsNull(middleFrame)) middleFrame = CGRectMake(0, bounds.size.height*0.5, bounds.size.width, 0);

	_topView.frame = CGRectMake(0, 0 + (_isSectionBackground ? headerHeight : 0), bounds.size.width, middleFrame.origin.y - (_isSectionBackground ? headerHeight : 0));
	CGFloat bottomY = middleFrame.origin.y + middleFrame.size.height;
	_bottomView.frame = CGRectMake(0, bottomY, bounds.size.width, bounds.size.height - bottomY);
	[_topView layoutSubviews];
	[_bottomView layoutSubviews];
}

+ (NSString *)elementKind {
	return @"ITXNCGroupBackgroundView";
}

- (void)setOverrideAlpha:(CGFloat)alpha {
	_overrideAlpha = alpha;
	self.alpha = _overrideAlpha;
}

- (void)setOverrideCenter:(CGPoint)center {
	_overrideCenter = center;
	self.center = _overrideCenter;
}

- (void)prepareForReuse {
	_isSectionBackground = NO;
	[super prepareForReuse];
	[self _resetRevealOverrides];
}

- (void)_resetRevealOverrides {
	_overrideAlpha = CGFLOAT_MAX;
	_overrideCenter = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
	_shouldOverrideForReveal = NO;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
	[super applyLayoutAttributes:attributes];
	if (_shouldOverrideForReveal) {
		if (_overrideAlpha != CGFLOAT_MAX) {
			[self setAlpha:_overrideAlpha];
		}

		if (_overrideCenter.x != CGFLOAT_MAX && _overrideCenter.y != CGFLOAT_MAX) {
			[self setCenter:_overrideCenter];
		}
	}
}
@end