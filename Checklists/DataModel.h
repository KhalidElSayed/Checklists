#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property (nonatomic, strong) NSMutableArray *lists;
-(void) saveChecklists;
-(int) indexOfSelectedChecklist;
-(void) setIndexOfSelectedChecklist:(int) index;
-(void) sortChecklists;
@end
