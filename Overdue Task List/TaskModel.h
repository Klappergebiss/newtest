//
//  TaskModel.h
//  Overdue Task List
//
//  Created by Tim Engel on 13.11.15.
//  Copyright © 2015 Tim Engel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property (strong, nonatomic)   NSString  *title;
@property (strong, nonatomic)   NSString  *detailDescription;
@property (strong, nonatomic)   NSDate    *date;
@property (nonatomic)           BOOL      isCompleted;

-(id)initWithData:(NSDictionary *)data;

@end
