//
//  ChecklistItem.h
//  Checklists
//
//  Created by Ashok Gelal on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL checked;

-(void) toggleChecked;
@end
