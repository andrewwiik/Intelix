@interface NCNotificationListSection : NSObject
-(id)initWithIdentifier:(NSString *)arg1 title:(NSString *)title;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,readonly) NSString *identifier; 
- (void)setSectionDate:(NSDate *)date;
- (NSDate *)sectionDate;
@end