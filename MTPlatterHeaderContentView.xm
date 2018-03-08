#import <Intelix/MTPlatterHeaderContentView.h>

%hook MTPlatterHeaderContentView
%property (nonatomic, assign) BOOL isIntelixSectionHeader;
- (CGSize)sizeThatFits:(CGSize)size {
	// HBLogInfo(@"Method #110");
	if (!self.isIntelixSectionHeader) return %orig;
	return CGSizeZero;
}

- (BOOL)isHidden {
	// HBLogInfo(@"Method #111");
	if (!self.isIntelixSectionHeader) return %orig;
	return YES;
}

- (void)setIsHidden:(BOOL)isHidden {
	// HBLogInfo(@"Method #112");
	%orig(!self.isIntelixSectionHeader ? isHidden : YES);
}

- (CGFloat)alpha {
	if (!self.isIntelixSectionHeader) return %orig;
	return 0.0;
}

- (void)setAlpha:(CGFloat)alpha {
	// HBLogInfo(@"Method #113");
	if (!self.isIntelixSectionHeader) {
		%orig;
		return;
	}
	%orig(0.0f);
}

- (CGFloat)_headerHeightForWidth:(CGFloat)width {
	// HBLogInfo(@"Method #114");
	if (!self.isIntelixSectionHeader) return %orig;
	return 0.0f;
}

- (CGFloat)contentBaseline {
	// HBLogInfo(@"Method #115");
	if (!self.isIntelixSectionHeader) return %orig;
	return 0;
}

- (void)layoutSubviews {
	%orig;
	// HBLogInfo(@"Method #116");
	//if (!!self.isIntelixSectionHeader) {
	[self setHidden:!self.isIntelixSectionHeader ? NO : YES];
}
%end