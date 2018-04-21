#import <Intelix/MTPlatterHeaderContentView.h>

%hook MTPlatterHeaderContentView
%property (nonatomic, assign) BOOL isInRecentsSection;
%property (nonatomic, assign) BOOL isInHistorySection;
- (CGSize)sizeThatFits:(CGSize)size {
	if (self.isInHistorySection) return CGSizeZero;
	return %orig;
}

- (BOOL)isHidden {
	if (self.isInHistorySection) return YES;
	if (self.isInRecentsSection) return NO;
	return %orig;
}

- (void)setIsHidden:(BOOL)isHidden {
	%orig(self.isInHistorySection ? YES : isHidden);
}

- (CGFloat)alpha {
	if (self.isInHistorySection) return 0.0;
	return %orig;
}

- (void)setAlpha:(CGFloat)alpha {
	%orig(self.isInHistorySection ? 0.0 : alpha);
}

- (CGFloat)_headerHeightForWidth:(CGFloat)width {
	if (self.isInHistorySection) return 0.0;
	return %orig;
}

- (CGFloat)contentBaseline {
	if (self.isInHistorySection) return 0.0;
	return %orig;
}

- (void)layoutSubviews {
	%orig;
	if (self.isInHistorySection || self.isInRecentsSection) [self setHidden:[self isHidden]];
}
%end