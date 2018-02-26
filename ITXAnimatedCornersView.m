#import <Intelix/ITXAnimatedCornersView.h>
#import <UIKit/UIView+Private.h>

@implementation ITXAnimatedCornersView

- (id)init {
	self = [super init];
	return self;
}
- (BOOL)shouldForwardSelector:(SEL)aSelector {
    return [self.layer respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return (![self respondsToSelector:aSelector] && [self shouldForwardSelector:aSelector]) ? self.layer : self;
}

- (BOOL)_shouldAnimatePropertyWithKey:(NSString *)key {
    //if ([key isEqual:@"_continuousCornerRadius"] || [key isEqual:@"_setContinuousCornerRadius:"]) return YES;
    return ([self shouldForwardSelector:NSSelectorFromString(key)] || [super _shouldAnimatePropertyWithKey:key]);
}
@end