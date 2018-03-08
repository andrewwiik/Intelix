#import <Intelix/ITXHelper.h>

static NSMutableDictionary *iconsToDict;

@implementation ITXHelper
+ (CGFloat)seperatorHeight {
	return 0.5f;
}
+ (CGFloat)standardInset {
	return 4.0f;
}
+ (CGFloat)standardCornerRadius {
	return 13.0f;
}

+ (UIImage *)iconForIdentifier:(NSString *)identifier {
	// HBLogInfo(@"Method #102");
	if (!iconsToDict) return nil;
	else return [iconsToDict objectForKey:identifier];
}

+ (void)setIcon:(UIImage *)icon forIdentifier:(NSString *)identifier {
	// HBLogInfo(@"Method #103");
	if (!iconsToDict) iconsToDict = [NSMutableDictionary new];
	if (icon) {
		[iconsToDict setObject:icon forKey:identifier];
	}
}
@end