#import "../UIKit/_UIBackdropView.h"

@interface MTMaterialView : UIView {
	_UIBackdropView *_backdropView;
}
@property (nonatomic,copy) NSString *groupName; 
@property (assign,nonatomic) BOOL allowsInPlaceFiltering;

+(MTMaterialView *)materialViewWithRecipe:(NSInteger)recipe options:(NSUInteger)options;

- (void)cbr_colorize:(id)colorInfo;
@end