@interface MTFontProvider
+ (instancetype)defaultFontProvider;
+ (instancetype)preferredFontProvider;
- (UIFont *)preferredFontForTextStyle:(id)textStyle hiFontStyle:(NSInteger)fontStyle;
@end
