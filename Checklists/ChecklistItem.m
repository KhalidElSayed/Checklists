#import "ChecklistItem.h"
#import "DataModel.h"

@implementation ChecklistItem

@synthesize text, checked;
@synthesize dueDate, shouldRemind, itemId;

-(void) toggleChecked{
    self.checked = !self.checked;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInt:self.itemId forKey:@"ItemID"];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if((self=[super init])){
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntForKey:@"ItemID"];
    }
    
    return self;
}

-(id) init{
    if(self=[super init]){
        self.itemId = [DataModel nextChecklistItemId];
    }
    
    return self;
}
-(void) scheduleNotification
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if(existingNotification != nil){
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
    if(self.shouldRemind && [self.dueDate compare:[NSDate date]]!= NSOrderedAscending)
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.itemId] forKey:@"ItemID"];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

-(UILocalNotification *) notificationForThisItem
{
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *notification in allNotifications) {
        NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
        if(number != nil){
            return notification;
        }
    }
    return nil;
}

-(void) dealloc
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if(existingNotification != nil){
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
}
@end
