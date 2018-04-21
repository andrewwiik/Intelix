#import <Intelix/ITXNCGroupBackgroundView.h>
#import <UIKit/UICollectionView+Private.h>
#import <UIKit/UICollectionReusableView+Private.h>
#import <Intelix/NCNotificationListCell.h>
#import <ColorBanners2/CBRColoringInfo.h>
#import <Intelix/ITXNCGroupFooterView.h>
#import <Intelix/NCNotificationShortLookView.h>
#import <Intelix/NCNotificationListSectionHeaderView.h>
static CGFloat headerHeight = 20;

@implementation ITXNCGroupBackgroundView

- (id)initWithFrame:(CGRect)frame {
	// HBLogInfo(@"Method #120");
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
	// HBLogInfo(@"Method #121");
	if (!CGRectEqualToRect(frame, _middleFrame)) {
		_middleFrame = frame;
		_previousFrame = CGRectZero;
		[self layoutSubviews];
	}
}

- (void)setForcedFrame:(CGRect)frame {
	// HBLogInfo(@"Method #122");
	if (!CGRectEqualToRect(frame, _forcedFrame)) {
		_forcedFrame = frame;
		[self layoutSubviews];
	}
}

- (void)setFrame:(CGRect)frame {
	// HBLogInfo(@"Method #123");
	[super setFrame:frame];
	[self layoutSubviews];
}

- (void)doConfigUpdate {
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
	_previousFrame = self.frame;

	if (NSClassFromString(@"CBRPrefsManager") && NSClassFromString(@"CBRColoringInfo")) {

		if ([self superview] && [[self superview] isKindOfClass:NSClassFromString(@"NCNotificationShortLookView")]) {
			NCNotificationShortLookView *shortLookView = (NCNotificationShortLookView *)[self superview];
			id coloringInfo = [shortLookView cbr_coloringInfo];
			if (coloringInfo) [self cbr_setColoringInfo:coloringInfo];
			if (_coloringInfo) {
				if (_backdropView && [_backdropView respondsToSelector:@selector(cbr_colorize:)]) {
					[_backdropView cbr_colorize:_coloringInfo];
				}
			}
		} else {
			UICollectionView *collectionView = self.collectionView;
			UICollectionViewLayoutAttributes *layoutAttributes = self.layoutAttributes;
			if (layoutAttributes && collectionView) {
				NSIndexPath *path = layoutAttributes.indexPath;
				if (path) {
					NCNotificationListCell *cell = [collectionView _visibleCellForIndexPath:path];
					if (cell) {
						id coloringInfo = [cell cbr_coloringInfo];
						if (coloringInfo) {
							[self cbr_setColoringInfo:coloringInfo];
							CBRColoringInfo *info = (CBRColoringInfo *)_coloringInfo;
							ITXNCGroupFooterView *footerView = [collectionView _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:path];
							if (footerView && [footerView isKindOfClass:NSClassFromString(@"ITXNCGroupFooterView")]) {
								[footerView setTextColor:info.contrastColorForLookType];
							}

							NCNotificationListSectionHeaderView *headerView = [collectionView _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" atIndexPath:path];
							if (headerView && [headerView isKindOfClass:NSClassFromString(@"NCNotificationListSectionHeaderView")]) {
								[headerView cbr_setColoringInfo:_coloringInfo];
							}

							if (_backdropView && [_backdropView respondsToSelector:@selector(cbr_colorize:)]) {
								[_backdropView cbr_colorize:_coloringInfo];
							}
						}
					}
				}
			}
		}

		// if (_coloringInfo) {
		// 	CBRColoringInfo *info = (CBRColoringInfo *)_coloringInfo;

		// }

		// if (_coloringInfo) {
		// 	[self cbr_colorize]
		// }
	}
}

- (void)layoutSubviews {
	// HBLogInfo(@"Method #124");
	[super layoutSubviews];
	//_isSectionBackground = NO;
	// Andy Remove this after testing
	//_forcedFrame = self.frame;
	// if (!CGRectIsNull(_forcedFrame))
	//CGRect forcedFrame = _forcedFrame;
	//self.frame = _forcedFrame;

	if (_previousFrame.size.width != self.frame.size.width || _previousFrame.size.height != self.frame.size.height || _backdropView.bounds.size.height != self.frame.size.height) {

		[self doConfigUpdate];
	}
}

+ (NSString *)elementKind {
	return @"ITXNCGroupBackgroundView";
}

- (void)setOverrideAlpha:(CGFloat)alpha {
	// HBLogInfo(@"Method #125");
	_overrideAlpha = alpha;
	if (!self.isTopSection) self.alpha = _overrideAlpha;
}

- (void)setOverrideCenter:(CGPoint)center {
	// HBLogInfo(@"Method #126");
	_overrideCenter = center;
	if (!self.isTopSection) self.center = _overrideCenter;
}

- (void)prepareForReuse {
	// HBLogInfo(@"Method #127");
	_isSectionBackground = NO;
	_isTopSection = NO;
	[super prepareForReuse];
	[self _resetRevealOverrides];
}

- (void)_resetRevealOverrides {
	// HBLogInfo(@"Method #128");
	_overrideAlpha = CGFLOAT_MAX;
	_overrideCenter = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
	_shouldOverrideForReveal = NO;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
	// HBLogInfo(@"Method #129");
	[super applyLayoutAttributes:attributes];
	if (_shouldOverrideForReveal && !self.isTopSection) {
		if (_overrideAlpha != CGFLOAT_MAX) {
			[self setAlpha:_overrideAlpha];
		}

		if (_overrideCenter.x != CGFLOAT_MAX && _overrideCenter.y != CGFLOAT_MAX) {
			[self setCenter:_overrideCenter];
		}
	}
}

- (void)cbr_setColoringInfo:(id)info {
	_coloringInfo = info;
}

- (id)cbr_coloringInfo {
	return _coloringInfo;
}
@end