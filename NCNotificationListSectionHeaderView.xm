#import <Intelix/NCNotificationListSectionHeaderView.h>
#import <Intelix/ITXHelper.h>
#import <Intelix/ITXNCGroupBackgroundView.h>
#import <Intelix/ITXNCGroupFooterView.h>
#import <UIKit/UICollectionReusableView+Private.h>
#import <UIKit/UICollectionView+Private.h>

%hook NCNotificationListSectionHeaderView
%property (nonatomic, retain) MTPlatterHeaderContentView *headerContainerView;
%property (nonatomic, retain) UIView *separatorView;
%property (nonatomic, retain) NSString *appIdentifier;
%property (nonatomic, retain) ITXNCGroupBackgroundView *sectionBackground;
%property (nonatomic, retain) ITXNCGroupFooterView *footerView;

- (void)setAlpha:(CGFloat)alpha {
	%orig;
	// UIView *thing = [self sectionBackground];
	// if (thing) {
	// 	thing.alpha = alpha;
	// }
}

%new
- (ITXNCGroupBackgroundView *)sectionBackgroundView {
	self.sectionBackground = nil;
	if (self.sectionBackground) return self.sectionBackground;
	else {
		if (self.collectionView) {
			self.sectionBackground = (ITXNCGroupBackgroundView * )[self.collectionView _visibleSupplementaryViewOfKind:[ITXNCGroupBackgroundView elementKind] atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[[self.collectionView indexPathForSupplementaryView:self] section]]];
		}
	}
	return self.sectionBackground;
}

%new
- (ITXNCGroupFooterView *)sectionFooterView {
	self.footerView = nil;
	if (self.footerView) return self.footerView;
	else {
		if (self.collectionView) {
			self.footerView = (ITXNCGroupFooterView * )[self.collectionView _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[[self.collectionView indexPathForSupplementaryView:self] section]]];
		}
	}
	return self.footerView;
	// if (self.collectionView) return (ITXNCGroupFooterView * )[self.collectionView _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[[self.collectionView indexPathForSupplementaryView:self] section]]];
	// else return nil;
}

-(id)initWithFrame:(CGRect)frame {
	NCNotificationListSectionHeaderView *orig = %orig;
	if (orig && !orig.headerContainerView) {
		orig.headerContainerView = [[NSClassFromString(@"MTPlatterHeaderContentView") alloc] init];
		//orig.headerContainerView.isIntelixSectionHeader = YES;
		[orig addSubview:orig.headerContainerView];

		CGFloat inset = 8;

		orig.separatorView = [[UIView alloc] initWithFrame:CGRectMake(inset, self.bounds.size.height - [ITXHelper seperatorHeight], self.bounds.size.width - (inset*2), [ITXHelper seperatorHeight])];
		orig.separatorView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];

		[self addSubview:orig.separatorView];
	}
	return orig;
}

- (void)layoutSubviews {
	%orig;

	if (self.clearButton) self.clearButton.hidden = YES;
	if (self.titleLabel) self.titleLabel.hidden = YES;

	if (self.headerContainerView) {
		CGFloat inset = 8;
		CGFloat headerContainerHeight = [self.headerContainerView sizeThatFits:self.bounds.size].height;
		self.headerContainerView.frame = CGRectMake(8, self.bounds.size.height - headerContainerHeight, self.bounds.size.width - (8*2), headerContainerHeight);
		self.separatorView.frame = CGRectMake(inset, self.bounds.size.height - [ITXHelper seperatorHeight], self.bounds.size.width - (inset*2), [ITXHelper seperatorHeight]);
	}
}

- (void)setTitle:(NSString *)title forSectionIdentifier:(NSString *)sectionIdentifier {
	if (title) {
		NSArray *components = [title componentsSeparatedByString:@"|"];
		if (components.count > 1) {
			self.appIdentifier = components[1];
		}
		title = components[0];
	} else {
		self.appIdentifier = @"";
	}

	if (self.headerContainerView) {
		self.headerContainerView.title = title;
		if (self.appIdentifier && self.appIdentifier.length > 0) {
			self.headerContainerView.icon = [ITXHelper iconForIdentifier:self.appIdentifier];
		}
	}

	%orig(title, sectionIdentifier);
	// self.titleLabel.text = 
	// %orig(title, sectionIdentifier);
	//[self setSectionIdentifier:sectionIdentifier];
//	[self.headerContentView setTitle:title];
	//[self.headerContentView setIcon:self.iconImage];
}

- (void)setOverrideAlpha:(CGFloat)alpha {
	%orig;
	ITXNCGroupBackgroundView *view = [self sectionBackgroundView];
	if (view) {
		view.overrideAlpha = self.overrideAlpha;
	}

	ITXNCGroupFooterView *footer = [self sectionFooterView];
	if (footer) {
		footer.overrideAlpha = self.overrideAlpha;
	}
}

- (void)setOverrideCenter:(CGPoint)center {
	%orig;
	ITXNCGroupBackgroundView *view = [self sectionBackgroundView];
	if (view) {
		CGPoint overrideCenter = self.overrideCenter;
		overrideCenter.y = (overrideCenter.y - self.bounds.size.height * 0.5) + (view.bounds.size.height * 0.5);
		view.overrideCenter = overrideCenter;

		ITXNCGroupFooterView *footer = [self sectionFooterView];
		if (footer) {
			CGPoint footerCenter = overrideCenter;
			footerCenter.y += (view.bounds.size.height * 0.5) - (footer.bounds.size.height * 0.5);
			footer.overrideCenter = footerCenter;
		}
	}
}

- (void)_resetRevealOverrides {
	%orig;
	ITXNCGroupBackgroundView *view = [self sectionBackgroundView];
	if (view) {
		[view _resetRevealOverrides];
	}

	ITXNCGroupFooterView *footer = [self sectionFooterView];
	if (footer) {
		[footer _resetRevealOverrides];
	}
}

- (void)setShouldOverrideForReveal:(BOOL)shouldOverride {
	%orig;
	ITXNCGroupBackgroundView *view = [self sectionBackgroundView];
	if (view) {
		view.shouldOverrideForReveal = self.shouldOverrideForReveal;
	}

	ITXNCGroupFooterView *footer = [self sectionFooterView];
	if (footer) {
		footer.shouldOverrideForReveal = self.shouldOverrideForReveal;
	}
}

- (void)prepareForReuse {
	%orig;
	self.footerView = nil;
	self.sectionBackground = nil;
	self.alpha= 1.0;
	self.hidden = NO;
	if (self.headerContainerView) {
		self.headerContainerView.icon = nil;
		self.headerContainerView.title = @"";
	}

	if (self.headerContainerView) {
		self.headerContainerView.title = @"";
		self.headerContainerView.icon = nil;
	}
}
%end