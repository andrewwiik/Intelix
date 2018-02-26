@interface ITXAnimatedCornersView : UIView
- (BOOL)shouldForwardSelector:(SEL)aSelector;
- (id)forwardingTargetForSelector:(SEL)aSelector;
- (BOOL)_shouldAnimatePropertyWithKey:(NSString *)key;
@end