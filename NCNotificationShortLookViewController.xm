#import <UserNotificationsUIKit/NCNotificationShortLookViewController.h>
#import <Intelix/MTPlatterHeaderContentView.h>
#import <MaterialKit/MTMaterialView.h>
#import <Intelix/NCNotificationCombinedListViewController.h>
#import <Intelix/NCNotificationShortLookView.h>
#import <dlfcn.h>
#import <UIKit/UIView+Private.h>


@interface NCNotificationShortLookView ()
@property (nonatomic, assign) BOOL isInRecentsSection;
@property (nonatomic, assign) BOOL isInHistorySection;
- (void)setInHistory:(BOOL)inHistory inRecents:(BOOL)inRecents;
@end

@interface NCNotificationShortLookViewController (ITXStuff)
@property (nonatomic, assign) BOOL isRegularHeader;
@property (nonatomic, assign) BOOL isInRecentsSection;
@property (nonatomic, assign) BOOL isInHistorySection;
@end

%hook NCNotificationShortLookViewController
%property (nonatomic, assign) BOOL isRegularHeader;
%property (nonatomic, assign) BOOL isInRecentsSection;
%property (nonatomic, assign) BOOL isInHistorySection;



- (void)_setupStaticContentProvider {
	%orig;
}

- (BOOL)_setNotificationRequest:(NCNotificationRequest *)request {
	if (request && [self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
		NCNotificationCombinedListViewController *controller = (NCNotificationCombinedListViewController *)[self valueForKey:@"_delegate"];
		BOOL isInRecentsSection = [controller _isNotificationRequestForLockScreenNotificationDestination:request];
		self.isInRecentsSection = isInRecentsSection;
		self.isInHistorySection = !isInRecentsSection;
	}

	return %orig;
}

// - (void)reloadStaticContentProvider {
// 	%orig;
// 	if ([self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
		
// 	}
// }

- (void)_updateWithProvidedStaticContent {
	NCNotificationShortLookView *lookView = (NCNotificationShortLookView *)MSHookIvar<UIView *>(self, "_lookView");
	if (lookView) {
		if ([self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
			[lookView setInHistory:self.isInHistorySection inRecents:self.isInRecentsSection];
		}
	}
	%orig;
}

- (void)setDelegate:(NSObject *)delegate {
	%orig;
	if ([self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
		if (self.notificationRequest) {
			NCNotificationCombinedListViewController *controller = (NCNotificationCombinedListViewController *)[self valueForKey:@"_delegate"];
			BOOL isInRecentsSection = [controller _isNotificationRequestForLockScreenNotificationDestination:self.notificationRequest];
			self.isInRecentsSection = isInRecentsSection;
			self.isInHistorySection = !isInRecentsSection;
		}

		NCNotificationShortLookView *lookView = (NCNotificationShortLookView *)MSHookIvar<UIView *>(self, "_lookView");
		if (lookView) {
			if ([self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
				[lookView setInHistory:self.isInHistorySection inRecents:self.isInRecentsSection];
			}
		}
	}
}

- (void)viewWillLayoutSubviews {
	//if (self.isRegularHeader) {
	// if ([self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
	// 	if (self.view) {
	// 		if (self.view.contentView) {
	// 			if ([self.view.contentView _headerContentView]) {
	// 				MTPlatterHeaderContentView *header = [self.view.contentView _headerContentView];
	// 				header.isIntelixSectionHeader = self.isRegularHeader ? NO : YES;
	// 				MTMaterialView *overlayView = [self.view.contentView valueForKey:@"_mainOverlayView"];
	// 				//overlayView._continuousCornerRadius = 0;
	// 				if (overlayView) {
	// 					overlayView.hidden = self.isRegularHeader ? NO : YES;
	// 					overlayView.alpha = self.isRegularHeader ? 1.0 : 0;
	// 					if (!self.isRegularHeader) [overlayView removeFromSuperview];
	// 				}
	// 			}
	// 		}
	// 	}
	// }
	//}
	%orig;

	// if ([self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
	// 	if (self.view) {
	// 		if (self.view.contentView) {
	// 			[self.view.contentView setValue:@(0) forKey:@"_recipe"];
	// 			if ([self.view.contentView _headerContentView]) {
	// 				MTPlatterHeaderContentView *header = [self.view.contentView _headerContentView];
	// 				header.isIntelixSectionHeader = YES;
	// 				MTMaterialView *overlayView = [self.view.contentView valueForKey:@"_mainOverlayView"];
	// 				//overlayView._continuousCornerRadius = 0;
	// 				if (overlayView) {
	// 					overlayView.hidden = YES;
	// 					overlayView.alpha = 0.0;
	// 					[overlayView removeFromSuperview];
	// 				}
	// 			}
	// 		}
	// 	}
	// }
}

- (void)_loadLookView {
	%orig;
	NCNotificationShortLookView *lookView = (NCNotificationShortLookView *)MSHookIvar<UIView *>(self, "_lookView");
	if (lookView) {
		if ([self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
			[lookView setInHistory:self.isInHistorySection inRecents:self.isInRecentsSection];

			if ([lookView respondsToSelector:@selector(setIsFromBannerWasSet:)]) {
				[lookView setIsFromBanner:NO];
				[lookView setIsFromBannerWasSet:YES];
			}
		}

		// if ([lookView respondsToSelector:@selector(setIsFromBannerWasSet:)]) {
		// 	[lookView setIsFromBanner:NO];
		// 	[lookView setIsFromBannerWasSet:YES];
		// }
	}
}
// 	if ([self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"SBNotificationBannerDestination")]) {
// 		self.isCombinedList = NO;
// 	} else {
// 		self.isCombinedList = YES;
// 	}
// 	%orig;
// 	NCNotificationShortLookView *view = (NCNotificationShortLookView *)MSHookIvar<UIView *>(self, "_lookView");
// 	if (view) {
// 		view.isCombinedList = self.isCombinedList;
// 	}
// 	// if (![self valueForKey:@"_lookView"]) {
// 	// 	NCNotificationShortLookView *lookView = [[NSClassFromString(@"NCNotificationShortLookView") alloc] init];
// 	// 	lookView.isCombinedList = self.isCombinedList;
// 	// 	[self setValue:lookView forKey:@"_lookView"];
// 	// }
// }

- (void)_notificationViewControllerViewDidLoad {
	// // HBLogInfo(@"Method #89");
	// if (self.isRegularHeader) {
	// 	if (self.view) {
	// 		if (self.view.contentView) {
	// 			if ([self.view.contentView _headerContentView]) {
	// 				MTPlatterHeaderContentView *header = [self.view.contentView _headerContentView];
	// 				header.isIntelixSectionHeader = NO;
	// 				header.alpha = 1.0;
	// 				header.hidden = NO;
	// 				MTMaterialView *overlayView = [self.view.contentView valueForKey:@"_mainOverlayView"];
	// 				//overlayView._continuousCornerRadius = 0;
	// 				if (overlayView) {
	// 					overlayView.hidden = NO;
	// 					overlayView.alpha = 1.0;
	// 					//[overlayView removeFromSuperview];
	// 				}
	// 			}
	// 		}
	// 	}
	// }

	%orig;
	//if (self.isRegularHeader) return;

	// if ([self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
	// 	if (self.view) {
	// 		if (self.view.contentView) {
	// 			if ([self.view.contentView _headerContentView]) {
	// 				MTPlatterHeaderContentView *header = [self.view.contentView _headerContentView];
	// 				header.isIntelixSectionHeader = self.isRegularHeader ? NO : YES;
	// 				MTMaterialView *overlayView = [self.view.contentView valueForKey:@"_mainOverlayView"];
	// 				//overlayView._continuousCornerRadius = 0;
	// 				if (overlayView) {
	// 					overlayView.hidden = self.isRegularHeader ? NO : YES;
	// 					overlayView.alpha = self.isRegularHeader ? 1.0 : 0;
	// 					if (!self.isRegularHeader) [overlayView removeFromSuperview];
	// 				}
	// 			}
	// 		}
	// 	}
	// }
}
%end

%hook NCNotificationShortLookView
%property (nonatomic, assign) BOOL isInRecentsSection;
%property (nonatomic, assign) BOOL isInHistorySection;
- (void)_configureHeaderContentView {
	%orig;
	if (self.isInHistorySection || self.isInRecentsSection) {
		MTPlatterHeaderContentView *headerContentView = [self _headerContentView];
		if (headerContentView) {
			headerContentView.isInRecentsSection = self.isInRecentsSection;
			headerContentView.isInHistorySection = self.isInHistorySection;
		}
	}
}


- (void)_configureMainOverlayViewIfNecessary {
	%orig;
	if (self.isInHistorySection || self.isInRecentsSection) {
		MTMaterialView *mainOverlayView = (MTMaterialView *)MSHookIvar<MTMaterialView *>(self, "_mainOverlayView");
		if (mainOverlayView) {
			mainOverlayView.hidden = self.isInHistorySection ? YES : NO;
		}
	}
}

%new
- (void)setInHistory:(BOOL)inHistory inRecents:(BOOL)inRecents {
	self.isInHistorySection = inHistory;
	self.isInRecentsSection = inRecents;
	MTPlatterHeaderContentView *headerContentView = [self _headerContentView];
	if (headerContentView) {
		headerContentView.isInRecentsSection = self.isInRecentsSection;
		headerContentView.isInHistorySection = self.isInHistorySection;
	}

	MTMaterialView *mainOverlayView = (MTMaterialView *)MSHookIvar<MTMaterialView *>(self, "_mainOverlayView");
	if (mainOverlayView) {
		mainOverlayView.hidden = self.isInHistorySection ? YES : NO;
	}
}
%end

// %hook MTPlatterHeaderContentView
// %property (nonatomic, assign) BOOL isInRecentsSection;
// %property (nonatomic, assign) BOOL isInHistorySection;


// %end
// - (BOOL)isBanner {
// 	return NO;
// }
// - (BOOL)isFromBanner {
// 	return NO;
// }
// // - (void)setIsFromBanner:(BOOL)isFrom {
// // 	NCNotificationShortLookViewController *controller = (NCNotificationShortLookViewController *)[self _viewControllerForAncestor];
// // 	if (controller) {
// // 		if ([controller valueForKey:@"_delegate"] && [[controller valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
// // 			%orig(NO);
// // 			return;
// // 		}
// // 	}
// // 	%orig;
// // }
// %end

%ctor {
	dlopen("/Library/MobileSubstrate/DynamicLibraries/PicoBanners.dylib", RTLD_NOW);
	%init;
}