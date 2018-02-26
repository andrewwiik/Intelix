@interface ITXHelper : NSObject
+ (CGFloat)seperatorHeight;
+ (CGFloat)standardInset;
+ (CGFloat)standardCornerRadius;
+ (UIImage *)iconForIdentifier:(NSString *)identifier;
+ (void)setIcon:(UIImage *)icon forIdentifier:(NSString *)identifier;
@end