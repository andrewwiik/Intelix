@interface MTPlatterHeaderContentView : UIView
- (id)init;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIButton *utilityButton;
- (CGSize)sizeThatFits;
@end