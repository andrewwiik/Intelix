#import <Intelix/NCNotificationListSection.h>

%hook NCNotificationListSection
%property (nonatomic, retain) NSString *otherSectionIdentifier;
%property (nonatomic, retain) UIImage *iconImage;
- (void)whatTheHell { // Need this for a theos bug
	return;
}
%end