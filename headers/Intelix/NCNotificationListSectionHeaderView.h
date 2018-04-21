#import <UserNotificationsUIKit/NCNotificationListSectionHeaderView.h>
#import "MTPlatterHeaderContentView.h"
#import "ITXNCGroupBackgroundView.h"
#import "ITXNCGroupFooterView.h"

@interface NCNotificationListSectionHeaderView (Intelix)
@property (nonatomic, retain) MTPlatterHeaderContentView *headerContainerView;
@property (nonatomic, retain) UIView *separatorView;
@property (nonatomic, retain) NSString *appIdentifier;

// Animation Stuffs
@property (nonatomic, retain) ITXNCGroupBackgroundView *sectionBackground;
@property (nonatomic, retain) ITXNCGroupFooterView *footerView;

@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) BOOL isTopSection;

- (ITXNCGroupBackgroundView *)sectionBackgroundView;
- (ITXNCGroupFooterView *)sectionFooterView;

// Clear All Stuff

@property (nonatomic, retain) NSIndexPath *indexPath;

// ColorBanners2 Support
- (void)cbr_setColoringInfo:(id)info;
@end