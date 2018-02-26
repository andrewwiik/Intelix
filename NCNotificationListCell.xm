#import <MaterialKit/MTMaterialView.h>
#import <Intelix/ITXNCGroupBackgroundView.h>
#import <Intelix/ITXNCGroupBackgroundConfiguration.h>
#import <Intelix/ITXHelper.h>
#import <Intelix/NCNotificationListCell.h>
#import <UIKit/UICollectionViewCell+Private.h>
#import <UIKit/UICollectionView+Private.h>

%hook NCNotificationListCell
%property (nonatomic, retain) ITXNCGroupBackgroundView *itxBackgroundView;
%property (nonatomic, retain) UIView *separatorView;
%property (nonatomic, assign) BOOL _isLastInSection;
%property (nonatomic, assign) BOOL _isFirstInSection;
%property (nonatomic, assign) BOOL hasFooterUnder;
%property (nonatomic, retain) UIView *cellOver;
%property (nonatomic, retain) UIView *cellUnder;
%property (nonatomic, retain) MTMaterialView *origBackgroundView;

%new
- (ITXNCGroupBackgroundView *)sectionBackgroundView {
	return [self.collectionView _visibleSupplementaryViewOfKind:[ITXNCGroupBackgroundView elementKind] atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[[self.collectionView indexPathForCell:self] section]]];
}

%new
- (BOOL)isLastInSection {
	return self._isLastInSection;
}

%new
- (void)setIsLastInSection:(BOOL)isLast {
	if (self.itxBackgroundView) {
	//if (isLast != self._isLastInSection) {
		self._isLastInSection = isLast;
		if (isLast) {
			if (!self.hasFooterUnder) {
				// self.itxBackgroundView.configuration
				// [self.itxBackgroundView setTopRadius:0 bottomRadius:1 withDelay:0.0];
			} else {
				// [self.itxBackgroundView setTopRadius:0 bottomRadius:0 withDelay:0.0];
			}
			self.separatorView.hidden = YES;
		} else {
			//[self.itxBackgroundView setTopRadius:0 bottomRadius:0 withDelay:0.0];
			self.separatorView.hidden = NO;
		}
	}
	//}
}

- (void)updateCellForContentViewController:(id)controller {
	%orig;

	if (!self.itxBackgroundView) {

			// self.origBackgroundView = [[(MTMaterialView *)self.contentViewController.view.contentView.backgroundMaterialView valueForKey:@"_backdropView"] valueForKey:@"_backdropEffectView"];
			self.origBackgroundView = (MTMaterialView *)self.contentViewController.view.contentView.backgroundMaterialView;
			self.origBackgroundView.hidden = YES;
			//self.itxBackgroundView = [[ITXNCGroupBackgroundView alloc] initWithFrame:CGRectMake(0, 0, self.contentViewController.view.frame.size.width, self.contentViewController.view.frame.size.height)];



		if (self.origBackgroundView) {
			//self.origBackgroundView.clipsToBounds = YES;
			// self.origBackgroundView 
			// if (separatorHeight == 0) {
			// 	separatorHeight = 1.0f/[UIScreen mainScreen].scale;
			// }

			self.itxBackgroundView = [[ITXNCGroupBackgroundView alloc] initWithFrame:CGRectMake(0, 0, self.contentViewController.view.frame.size.width, self.contentViewController.view.frame.size.height)];
			//self.itxBackgroundView.layer.scale = 0.25;
			//self.itxBackgroundView.layer.groupName = @"ITXNCCellBackground";
			// self.itxBackgroundView.layer.groupName = @"ITXNCCellBackground";
			// [self.itxBackgroundView setContinousCornerRadius:13];
			// self.itxBackgroundView.clipValue = 4;
			
			// NSMutableArray *filters = [NSMutableArray new];
			// CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"gaussianBlur"];
			// [filter setValue:[NSNumber numberWithFloat:30] forKey:@"inputRadius"];
			// [filter setValue:@YES forKey:@"inputHardEdges"];
			// [filters addObject:filter];

			// CAFilter *filter1 = [NSClassFromString(@"CAFilter") filterWithType:@"colorSaturate"];
			// [filter1 setValue:[NSNumber numberWithFloat:2.04] forKey:@"inputAmount"];
			// [filters addObject:filter1];

			// [self.itxBackgroundView.layer setFilters:[filters copy]];
			// self.itxBackgroundView.layer.scale = 0.25;
			// self.itxBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.44];
			// [self.itxBackgroundView setTopRadius:0.0 bottomRadius:0.0 withDelay:0];

			// self.whiteOverlayView = [[UIView alloc] initWithFrame:self.itxBackgroundView.bounds];
			// self.whiteOverlayView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.2];
			// [self.itxBackgroundView addSubview:self.whiteOverlayView];

			// self._cornerRadiusForCell = [self.itxBackgroundView cornerRadiusBeingUsed];

			// [self.contentViewController.view addSubview:self.itxBackgroundView];
			// [self.contentViewController.view sendSubviewToBack:self.itxBackgroundView];

			CGRect backgroundFrame = self.itxBackgroundView.frame;
			CGFloat inset = 15.0;

			self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(inset, backgroundFrame.size.height - [ITXHelper seperatorHeight], backgroundFrame.size.width - inset, [ITXHelper seperatorHeight])];
			self.separatorView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];

			// self.origBackgroundView._continuousCornerRadius = 0;
			if ([self.contentViewController.view.contentView valueForKey:@"_mainOverlayView"]) {
				MTMaterialView *overlayView = [self.contentViewController.view.contentView valueForKey:@"_mainOverlayView"];
				//overlayView._continuousCornerRadius = 0;
				overlayView.hidden = YES;
				overlayView.alpha = 0;
			}

			// self.origBackgroundView = (MTMaterialView *)self.contentViewController.view.contentView;
			// // self.origBackgroundView.clipsToBounds = YES;
			// self.origBackgroundView.hidden = YES;
			// self.origBackgroundView.alpha = 0;
			[[self.origBackgroundView superview] addSubview:self.itxBackgroundView];
			[[self.origBackgroundView superview] sendSubviewToBack:self.itxBackgroundView];

			if (self.isLastInSection) {
				// if (!self.hasFooterUnder) {
				// 	[self.itxBackgroundView setTopRadius:0 bottomRadius:1 withDelay:0.0];
				// } else {
				// 	[self.itxBackgroundView setTopRadius:0 bottomRadius:0 withDelay:0.0];
				// }
				self.separatorView.hidden = YES;
			} else {
				//[self.itxBackgroundView setTopRadius:0 bottomRadius:0 withDelay:0.0];
				self.separatorView.hidden = NO;
			}

			self.itxBackgroundView.hidden = YES;
		}

		[[self.origBackgroundView superview] addSubview:self.separatorView];
	}
	if (self.contentViewController && self.contentViewController.view && self.contentViewController.view.contentView) {
		if ([self.contentViewController.view.contentView valueForKey:@"_mainOverlayView"]) {
			MTMaterialView *overlayView = [self.contentViewController.view.contentView valueForKey:@"_mainOverlayView"];
			//overlayView._continuousCornerRadius = 0;
			overlayView.hidden = YES;
			overlayView.alpha = 0;
		}
	}

	[self layoutSubviews];

}

-(void)_updateRevealForActionButtonsClippingRevealView:(id)clippingView actionButtonsView:(id)buttonsView forRevealPercentage:(CGFloat)percentage actionButtonsViewNeedsClipping:(BOOL)needsClipping {
	%orig;
	if (self.contentViewController && self.contentViewController.view) {
		UIView *offsetCalcView = self.contentViewController.view;
		CGFloat percentComplete = fmaxf(fminf(fabs(offsetCalcView.frame.origin.x)/(13*0.8), 1.0), 0.0);

	// 	if (!self.cellUnder && !self.cellOver) {
	// 		UICollectionView *collectionView = self.collectionView;
	// 		NSIndexPath *currentIndexPath = [self.collectionView indexPathForCell:self];
	// 		if (self._isLastInSection && self._isFirstInSection) {
	// 			//self.cellOver = (UIView *)[collectionView _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[currentIndexPath section]]];
	// 		} else if (self._isFirstInSection) {
	// 			//self.cellOver = (UIView *)[collectionView _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[currentIndexPath section]]];
	// 			self.cellUnder = (UIView *)[collectionView _visibleCellForIndexPath:[NSIndexPath indexPathForRow:[currentIndexPath row] + 1 inSection:[currentIndexPath section]]];
	// 		} else if (self._isLastInSection) {
	// 			self.cellOver = (UIView *)[collectionView _visibleCellForIndexPath:[NSIndexPath indexPathForRow:[currentIndexPath row] - 1 inSection:[currentIndexPath section]]];
	// 			if (self.hasFooterUnder) {
	// 				//self.cellUnder = (UIView *)[collectionView _visibleSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[currentIndexPath section]]];
	// 			}
	// 		} else {
	// 			self.cellOver = (UIView *)[collectionView _visibleCellForIndexPath:[NSIndexPath indexPathForRow:[currentIndexPath row] - 1 inSection:[currentIndexPath section]]];
	// 			self.cellUnder = (UIView *)[collectionView _visibleCellForIndexPath:[NSIndexPath indexPathForRow:[currentIndexPath row] + 1 inSection:[currentIndexPath section]]];
	// 		}
	// 	}

		CGFloat standardRadius = [ITXHelper standardCornerRadius];
		CGFloat standardInset = [ITXHelper standardInset];

		//if (!self._isFirstInSection || !self._isLastInSection) {
		ITXNCGroupBackgroundView *sectionBackground = [self sectionBackgroundView];
		ITXNCGroupBackgroundConfiguration *sectionConfig = sectionBackground.configuration;
		ITXNCGroupBackgroundConfiguration *cellConfig = self.itxBackgroundView.configuration;
		// if ((!self._isLastInSection && !self._isFirstInSection) || !self._isLastInSection) {
		// 	sectionConfig.middleTopRadius = standardRadius*percentComplete;
		// 	sectionConfig.middleBottomRadius = standardRadius*percentComplete;
		// 	sectionConfig.middleTopInset = standardInset*percentComplete;
		// 	sectionConfig.middleBottomInset = standardInset*percentComplete;
		// 	cellConfig.topRadius = standardRadius*percentComplete;
		// 	cellConfig.bottomRadius = standardRadius*percentComplete;
		// } else {
		sectionConfig.middleTopRadius = standardRadius*percentComplete;
		sectionConfig.middleBottomRadius = standardRadius*percentComplete;
		sectionConfig.middleTopInset = standardInset*percentComplete;
		sectionConfig.middleBottomInset = standardInset*percentComplete;
		cellConfig.topRadius = standardRadius*percentComplete;
		if (self._isLastInSection && !self.hasFooterUnder) {
			cellConfig.bottomRadius = standardRadius;
		} else {
			cellConfig.bottomRadius = standardRadius*percentComplete;
		}

		// sectionBackground.config = sectionConfig;
		if (percentComplete > 0.01) {
			self.itxBackgroundView.hidden = NO;
			sectionBackground.middleFrame = [[sectionBackground superview] convertRect:self.frame toView:sectionBackground];
			[self.itxBackgroundView layoutSubviews];
			[sectionBackground layoutSubviews];
		} else {
			sectionBackground.middleFrame = CGRectNull;
			self.itxBackgroundView.hidden = YES;
			[self.itxBackgroundView layoutSubviews];
			[sectionBackground layoutSubviews];
		}
		// }
		//}

		// if (percentage < 0.01 && percentage > -0.01) {
		// 	self.cellUnder = nil;
		// 	self.cellOver = nil;
		// }
	}
}

- (void)setContentViewController:(id)thing {
	%orig;
	[self layoutSubviews];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)attributes {
	// if (attributes.size.height < 1) {
	// 	attributes.alpha = 0;
	// }

	//attributes.transform = CGAffineTransformIdentity;

	UICollectionViewLayoutAttributes *orig = %orig;
	orig.alpha = 1.0;
	return orig;
}

- (void)_setLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
	//attributes.alpha = 1.0;
	// if (attributes.frame.size.height == 1) {
	// 	attributes.transform = CGAffineTransformMakeScale(1, 0);
	// } else {
	attributes.transform = CGAffineTransformIdentity;
	// }
	%orig(attributes);
}


- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
	CGRect frame = attributes.frame;
	frame.origin.x = 8;
	attributes.frame = frame;
	// if (attributes.frame.size.height == 1) {
	// 	attributes.transform = CGAffineTransformMakeScale(1, 0);
	// } else {
	attributes.transform = CGAffineTransformIdentity;
	// }
	//if (self.itxBackgroundView) self.itxBackgroundView.alpha = 1.0;
	[self layoutSubviews];
	%orig(attributes);
	[self layoutSubviews];
	//self.alpha = 1.0;
	//if (self.itxBackgroundView) self.itxBackgroundView.alpha = 1.0;
	// if (attributes.frame.size.height == 1) {
		//attributes.transform = CGAffineTransformMakeScale(1, 0);
	// } else {
	// 	attributes.transform = CGAffineTransformIdentity;
	// }
}

- (void)setConfigured:(BOOL)configed {
	%orig;
	[self layoutSubviews];
}

- (void)layoutSubviews {
	%orig;
	if (self.contentViewController && self.contentViewController.view && self.contentViewController.view.contentView) {
		CGFloat inset = 15.0;
		CGRect backgroundFrame = self.bounds;
		// backgroundFrame.size.width = backgroundFrame.size.width - (8*2);
		if (self.itxBackgroundView) {
			self.itxBackgroundView.frame = backgroundFrame;
		}
		//self.whiteOverlayView.frame = backgroundFrame;
		self.separatorView.frame = CGRectMake(inset, backgroundFrame.size.height - [ITXHelper seperatorHeight], backgroundFrame.size.width - inset, [ITXHelper seperatorHeight]);
		if ([self.contentViewController.view.contentView valueForKey:@"_mainOverlayView"]) {
			MTMaterialView *overlayView = [self.contentViewController.view.contentView valueForKey:@"_mainOverlayView"];
			//overlayView._continuousCornerRadius = 0;
			overlayView.hidden = YES;
			overlayView.alpha = 0.0;
		}

		//self.clipsToBounds = YES;
		self.origBackgroundView.hidden = YES;
	}

	if (self.origBackgroundView && self.itxBackgroundView) {
		if (![self.itxBackgroundView superview]) {
			[[self.origBackgroundView superview] addSubview:self.itxBackgroundView];
			[[self.origBackgroundView superview] sendSubviewToBack:self.itxBackgroundView];
			//self.origBackgroundView.maskView = self.itxBackgroundView;
		}

		if ([self.itxBackgroundView superview] != [self.origBackgroundView superview]) {
			[self.itxBackgroundView removeFromSuperview];
			[[self.origBackgroundView superview] addSubview:self.itxBackgroundView];
			[[self.origBackgroundView superview] sendSubviewToBack:self.itxBackgroundView];
		}

		if (self.isLastInSection) {
			// if (!self.hasFooterUnder) {
			// 	[self.itxBackgroundView setTopRadius:0 bottomRadius:1 withDelay:0.0];
			// } else {
			// 	[self.itxBackgroundView setTopRadius:0 bottomRadius:0 withDelay:0.0];
			// }
			self.separatorView.hidden = YES;
		} else {
			//[self.itxBackgroundView setTopRadius:0 bottomRadius:0 withDelay:0.0];
			self.separatorView.hidden = NO;
		}

		// self.itxBackgroundView
	}
}

- (void)prepareForReuse {
	if (self.itxBackgroundView) {
		ITXNCGroupBackgroundConfiguration *configuration = self.itxBackgroundView.configuration;
		configuration.topRadius = 0;
		configuration.bottomRadius = 0;
		[self.itxBackgroundView layoutSubviews];
		// [self.itxBackgroundView removeFromSuperview];
		// self.itxBackgroundView = nil;
	}
	self.hasFooterUnder = NO;
	self.isLastInSection = NO;
	%orig;
}
%end