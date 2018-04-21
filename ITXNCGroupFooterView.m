#import <Intelix/ITXHelper.h>
#import <Intelix/ITXNCGroupFooterView.h>
#import <QuartzCore/QuartzCore+Private.h>
#import <Intelix/NCNotificationCombinedListViewController.h>
#import <MaterialKit/MTFontProvider.h>

@implementation ITXNCGroupFooterView
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, [ITXHelper seperatorHeight])];
		self.separatorView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
		[self addSubview:self.separatorView];
		self.layer.allowsGroupBlending = NO;

		self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleShowAllNotifications)];
		[self addGestureRecognizer:self.tapRecognizer];
		self.tapRecognizer.cancelsTouchesInView = NO;
		self.tapRecognizer.numberOfTouchesRequired = 1;
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.separatorView.frame = CGRectMake(8, 0, self.bounds.size.width - (8*2), [ITXHelper seperatorHeight]);
	// if (_middleLabel) {
	// [_middleLabel sizeToFit];
	// _middleLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)setupMiddleLabel {
	if (!_middleLabel) {
		_middleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_middleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.75];
		_middleLabel.font = [[NSClassFromString(@"MTFontProvider") preferredFontProvider] preferredFontForTextStyle:UIFontTextStyleFootnote hiFontStyle:3];
		
		CAFilter *vibrancyFilter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantLight"];
		[vibrancyFilter setValue:[UIColor colorWithWhite:0.4 alpha:1] forKey:@"inputColor0"];
		[vibrancyFilter setValue:[UIColor colorWithWhite:0 alpha:0.3] forKey:@"inputColor1"];
		[vibrancyFilter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];

		_middleLabel.layer.filters = [NSArray arrayWithObjects:vibrancyFilter, nil];
		[self addSubview:_middleLabel];

	}
}

- (void)setNumberToShow:(NSInteger)numToShow {
	if (numToShow != _numberToShow) {
		_numberToShow = numToShow;
		if (_isExpanded) {
			[self setLabelText:[NSString stringWithFormat:@"Show Less"]];
		} else {
			[self setLabelText:[NSString stringWithFormat:@"Show %d more", (int)_numberToShow]];
		}
		//[self setLabelText:[NSString stringWithFormat:@"Show %d more", (int)_numberToShow]];
	}
}

- (void)setLabelText:(NSString *)text {
	if (!_middleLabel) {
		[self setupMiddleLabel];
	}
	if (text != _middleLabel.text) {
		_middleLabel.text = text;
		[_middleLabel sizeToFit];
		_middleLabel.center = CGPointMake(self.bounds.size.width/2 + 8, self.bounds.size.height/2);
	}
}

- (void)setIsExpanded:(BOOL)isExpanded {
	if(_isExpanded != isExpanded) {
		_isExpanded = isExpanded;
		if (_isExpanded) {
			[self setLabelText:[NSString stringWithFormat:@"Show Less"]];
		} else {
			[self setLabelText:[NSString stringWithFormat:@"Show %d more", (int)_numberToShow]];
		}
	}

}

- (void)toggleShowAllNotifications {
	if (self.cellDelegate) {
		// self.isExpanded = !self.isExpanded;
		[self.cellDelegate sectionFooterView:self didReceiveToggleExpansionActionForSectionIdentifier:self.sectionIdentifier];
	}
	// if (self.backgroundColor == [UIColor redColor]) {
	// 	self.backgroundColor = [UIColor blueColor];
	// } else {
	// 	self.backgroundColor = [UIColor redColor];
	// }
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
	[super prepareForReuse];
	[self _resetRevealOverrides];
}

- (void)_resetRevealOverrides {
	_overrideAlpha = CGFLOAT_MAX;
	_overrideCenter = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
	_shouldOverrideForReveal = NO;
}

- (void)setTextColor:(UIColor *)color {
	if (_middleLabel) {
		_middleLabel.textColor = color;
		_middleLabel.layer.filters = nil;
	}
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