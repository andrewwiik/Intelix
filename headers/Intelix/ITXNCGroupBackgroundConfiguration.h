@interface ITXNCGroupBackgroundConfiguration : NSObject
@property (nonatomic, assign, readwrite) CGFloat topRadius;
@property (nonatomic, assign, readwrite) CGFloat middleTopRadius;
@property (nonatomic, assign, readwrite) CGFloat middleBottomRadius;
@property (nonatomic, assign, readwrite) CGFloat bottomRadius;
@property (nonatomic, assign, readwrite) CGFloat middleTopInset;
@property (nonatomic, assign, readwrite) CGFloat middleBottomInset;
+ (ITXNCGroupBackgroundConfiguration *)defaultConfiguration;
+ (CGFloat)defaultCornerRadiusValue;
+ (CGFloat)defaultInsetValue;
@end