#import <Intelix/ITXNCGroupBackgroundView.h>
#import <Intelix/NCNotificationCombinedListViewController.h>

@interface NCNotificationListCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,retain) NSMutableArray * insertedIndexPaths;
@property (nonatomic,retain) NSMutableArray * removedIndexPaths;
@property (nonatomic,retain) NSMutableArray * replacedIndexPaths;
@end

// @interface NCNotificationCombinedListViewController : UICollectionViewController
// @end



%hook UIView
%new
- (void)testCornersThing {
	ITXNCGroupBackgroundView *corners = [[ITXNCGroupBackgroundView alloc] init];
	[self addSubview:corners];
	corners.frame = CGRectMake(0, self.bounds.size.height*0.25, self.bounds.size.width, self.bounds.size.height*0.5);
	[self bringSubviewToFront:corners];
	// corners.topCornerRadius = 13;
	// corners.bottomCornerRadius = 13;
	// corners.topInset = 20;
	// corners.bottomInset = 50;
	[corners layoutSubviews];
}
%end

@interface UICollectionViewFlowLayout (ITXPrivate)
- (CGRect)itx_frameForSection:(NSInteger)section;
@end

%hook NCNotificationListSectionRevealHintView
// - (void)_updateHintTitle {
// 	// HBLogInfo(@"I am Crashing Here");
// }

- (NSDate *)titleDate {
	// HBLogInfo(@"Method #107");
	NSDate *date = [NSDate date];
	return date;
}
%end

%hook NSCalendar
- (BOOL)isDateInToday:(NSDate *)date {
	// HBLogInfo(@"Method #108");
	NSDate *theDate = date;
	if (!theDate || theDate == nil) {
		theDate = [NSDate date];
	}
	BOOL result = %orig(theDate);
	return result;
}
%end

%hook NCNotificationChronologicalList
- (id)_titleForDate:(id)date {
	// HBLogInfo(@"Method #109");
	if (!date || date == nil) {
		date = [NSDate date];
	}
	// HBLogInfo(@"I am Crashing Here #2");
	return %orig(date);
	// return %orig;
}
%end

@interface SBCoverSheetSlidingViewController : UIViewController
@property (assign,nonatomic) NSInteger dismissalSlidingMode;   
@end

@interface SBDashBoardCombinedListViewController : UIViewController
@end

// %hook SBDashBoardCombinedListViewController
// - (void)_updatePresentation {
// 	%orig;
// 	NCNotificationCombinedListViewController *controller = [self valueForKey:@"_listViewController"];
// 	if (controller) {
// 		[controller _resetNotificationsHistory];
// 		[controller forceNotificationHistoryRevealed:TRUE animated:NO];
// 	}
// }
// %end

// %hook MTMaterialView
// - (void)cbr_colorize:(id)thing {
// 	HBLogInfo(@"CBR COLORIZE");
// 	HBLogInfo(@"%@", thing);
// 	%orig;
// }
// %end


%hook SBCoverSheetSlidingViewController
- (void)_finishTransitionToPresented:(BOOL)arg1 animated:(BOOL)arg2 withCompletion:(id)arg3 {
	if (self.dismissalSlidingMode != 1 && arg1 == false) return;
	%orig;
}
%end