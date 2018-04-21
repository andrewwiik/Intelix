#import <UserNotificationsUIKit/NCNotificationShortLookView.h>

@interface NCNotificationShortLookView (ColorBanners2)
- (id)cbr_coloringInfo;
@end

@interface NCNotificationShortLookView (PicoBanners2) 
- (void)setIsFromBanner:(BOOL)isBanner;
- (void)setIsFromBannerWasSet:(BOOL)wasSet;
- (BOOL)isBanner;
- (BOOL)isFromBanner;
- (BOOL)isFromBannerWasSet;
@end