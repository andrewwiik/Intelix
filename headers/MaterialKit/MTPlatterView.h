#import <MaterialKit/MTMaterialView.h>

@interface MTPlatterView : UIView {
	MTMaterialView* _mainOverlayView;
}

@property (nonatomic,readonly) MTMaterialView *backgroundMaterialView;
@property (assign,nonatomic) BOOL usesBackgroundView;
@property (nonatomic,retain) UIView *backgroundView;
- (MTPlatterView *)initWithRecipe:(NSInteger)recipe options:(NSUInteger)options;

// For Notifications: recipe: 1 options: 2
@end