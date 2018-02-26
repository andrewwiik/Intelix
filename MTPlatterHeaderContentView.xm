#import <Intelix/MTPlatterHeaderContentView.h>

%hook MTPlatterHeaderContentView
%property (nonatomic, assign) BOOL isIntelixSectionHeader;
- (CGSize)sizeThatFits:(CGSize)size {
	if (!self.isIntelixSectionHeader) return %orig;
	return CGSizeZero;
}

- (BOOL)isHidden {
	if (!self.isIntelixSectionHeader) return %orig;
	return YES;
}

- (void)setIsHidden:(BOOL)isHidden {
	%orig(!self.isIntelixSectionHeader ? isHidden : YES);
}

- (CGFloat)alpha {
	if (!self.isIntelixSectionHeader) return %orig;
	return 0.0;
}

- (void)setAlpha:(CGFloat)alpha {
	if (!self.isIntelixSectionHeader) {
		%orig;
		return;
	}
	%orig(0.0f);
}

- (CGFloat)_headerHeightForWidth:(CGFloat)width {
	if (!self.isIntelixSectionHeader) return %orig;
	return 0.0f;
}

- (CGFloat)contentBaseline {
	if (!self.isIntelixSectionHeader) return %orig;
	return 0;
}

- (void)layoutSubviews {
	%orig;
	//if (!!self.isIntelixSectionHeader) {
	[self setHidden:!self.isIntelixSectionHeader ? NO : YES];
}
%end