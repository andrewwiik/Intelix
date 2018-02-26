#import <MaterialKit/MTMaterialView.h>
#import <MaterialKit/MTPlatterHeaderContentView.h>

@interface NCNotificationShortLookView : UIView
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) MTMaterialView *backgroundMaterialView;
- (MTPlatterHeaderContentView *)_headerContentView;
@end