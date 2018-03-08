#import <UserNotificationsUIKit/NCNotificationShortLookViewController.h>
#import <Intelix/MTPlatterHeaderContentView.h>
#import <MaterialKit/MTMaterialView.h>

%hook NCNotificationShortLookViewController
- (void)setDelegate:(NSObject *)delegate {
	%orig;
	// HBLogInfo(@"Method #88");
	if (delegate && [delegate isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
		if (self.view) {
			if (self.view.contentView) {
				[self.view.contentView setValue:@(0) forKey:@"_recipe"];
				if ([self.view.contentView _headerContentView]) {
					MTPlatterHeaderContentView *header = [self.view.contentView _headerContentView];
					header.isIntelixSectionHeader = YES;
					MTMaterialView *overlayView = [self.view.contentView valueForKey:@"_mainOverlayView"];
					//overlayView._continuousCornerRadius = 0;
					if (overlayView) {
						overlayView.hidden = YES;
						overlayView.alpha = 0.0;
						[overlayView removeFromSuperview];
					}
				}
			}
		}
	}
}

- (void)viewWillLayoutSubviews {
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

- (void)_notificationViewControllerViewDidLoad {
	// HBLogInfo(@"Method #89");
	%orig;

	if ([self valueForKey:@"_delegate"] && [[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"NCNotificationCombinedListViewController")]) {
		if (self.view) {
			if (self.view.contentView) {
				[self.view.contentView setValue:@(0) forKey:@"_recipe"];
				if ([self.view.contentView _headerContentView]) {
					MTPlatterHeaderContentView *header = [self.view.contentView _headerContentView];
					header.isIntelixSectionHeader = YES;
					MTMaterialView *overlayView = [self.view.contentView valueForKey:@"_mainOverlayView"];
					//overlayView._continuousCornerRadius = 0;
					if (overlayView) {
						overlayView.hidden = YES;
						overlayView.alpha = 0.0;
						[overlayView removeFromSuperview];
					}
				}
			}
		}
	}
}
%end