@interface MTPlatterHeaderContentView : UIView
- (id)init;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSString *title;
- (CGSize)sizeThatFits;
@end