//
//  TaskModel.m
//  Overdue Task List
//
//  Created by Tim Engel on 13.11.15.
//  Copyright © 2015 Tim Engel. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel

-(id)init {
    self = [self initWithData:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data {
    self = [super init];
    
    if (self) {
        self.title = data[TASK_TITLE];
        self.detailDescription = data[TASK_DESCRIPTION];
        self.date = data[TASK_DATE];
        self.isCompleted = [data[TASK_COMPLETION] boolValue];
    }
    
    return self;
}

@end
