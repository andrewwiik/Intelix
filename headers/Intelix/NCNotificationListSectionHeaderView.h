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

- (ITXNCGroupBackgroundView *)sectionBackgroundView;
- (ITXNCGroupFooterView *)sectionFooterView;
@end