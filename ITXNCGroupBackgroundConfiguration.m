#import <Intelix/ITXNCGroupBackgroundConfiguration.h>

@implementation ITXNCGroupBackgroundConfiguration
- (id)init {
	self = [super init];
	if (self) {
		_topRadius = 0;
		_middleTopRadius = 0;
		_middleBottomRadius = 0;
		_bottomRadius = 0;

		_middleTopInset = 0;
		_middleBottomInset = 0;
	}
	return self;
}

+ (ITXNCGroupBackgroundConfiguration *)defaultConfiguration {
	ITXNCGroupBackgroundConfiguration *config = [ITXNCGroupBackgroundConfiguration new];
	CGFloat defaultCornerRadius = [ITXNCGroupBackgroundConfiguration defaultCornerRadiusValue];
	config.topRadius = defaultCornerRadius;
	config.bottomRadius = defaultCornerRadius;
	return config;
}

+ (CGFloat)defaultCornerRadiusValue {
	return 13.0f;
}
+ (CGFloat)defaultInsetValue {
	return 5.0f;
}
@end