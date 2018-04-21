#import <UserNotificationsUIKit/NCNotificationChronologicalList.h>

@interface NCNotificationChronologicalList (Intelix)
@property (nonatomic, retain) NSMutableArray *collapsedSectionIdentifiers;
@property (nonatomic, retain) NSMutableArray *expandedSectionIdentifiers;
- (BOOL)sectionIsCollapsed:(NSUInteger)section;
- (BOOL)sectionIsExpanded:(NSUInteger)sectionIndex;
- (NSUInteger)actualNumberOfNotificationsInSection:(NSUInteger)section;
- (NSString *)otherSectionIdentifierForSectionIndex:(NSUInteger)section;
- (void)toggleExpansionForSectionIdentifier:(NSString *)sectionIdentifier;
- (BOOL)sectionHasFooter:(NSUInteger)sectionIndex;
- (NSUInteger)sectionIndexForOtherSectionIdentifier:(NSString *)otherSectionIdentifier;

// Clear All
- (void)clearNotificationsInSection:(NSUInteger)section;
@end