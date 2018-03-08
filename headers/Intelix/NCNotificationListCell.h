#import <UserNotificationsUIKit/NCNotificationListCell.h>
#import <Intelix/ITXNCGroupBackgroundView.h>

@interface NCNotificationListCell (Intelix)
@property (nonatomic, retain) NCNotificationViewController *contentViewController;
@property (nonatomic, retain) ITXNCGroupBackgroundView *itxBackgroundView;
@property (nonatomic, retain) UIView *cellOver;
@property (nonatomic, retain) UIView *cellUnder;
@property (nonatomic, assign) BOOL _isLastInSection;
@property (nonatomic, assign) BOOL isLastInSection;
@property (nonatomic, assign) BOOL _isFirstInSection;
@property (nonatomic, assign) BOOL hasFooterUnder;
@property (nonatomic, retain) UIView *separatorView;
- (ITXNCGroupBackgroundView *)sectionBackgroundView;
- (void)doITXStuff;
@end