#import <MaterialKit/MTMaterialView.h>
#import "NCNotificationViewController.h"

@interface NCNotificationListCell : UICollectionViewCell
@property (nonatomic, retain) NCNotificationViewController *contentViewController;
@property (nonatomic, retain) MTMaterialView *origBackgroundView;
- (void)_updateRevealForActionButtonsClippingRevealView:(id)clippingView actionButtonsView:(id)buttonsView forRevealPercentage:(CGFloat)percentage actionButtonsViewNeedsClipping:(BOOL)needsClipping;
- (id)cbr_coloringInfo;
@end