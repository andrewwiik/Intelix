#import <MaterialKit/MTPlatterHeaderContentView.h>

@interface MTPlatterHeaderContentView (Intelix)
@property (nonatomic, assign) BOOL isInRecentsSection;
@property (nonatomic, assign) BOOL isInHistorySection;
@end

@interface MTPlatterHeaderContentView (ColorBanners2)
- (void)cbr_setColoringInfo:(id)info;
- (id)cbr_coloringInfo;
- (void)cbr_colorize:(id)info;
@end