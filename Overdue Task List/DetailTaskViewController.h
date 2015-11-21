//
//  DetailTaskViewController.h
//  Overdue Task List
//
//  Created by Tim Engel on 13.11.15.
//  Copyright © 2015 Tim Engel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "EditTaskViewController.h"

@protocol DetailTaskViewControllerDelegate <NSObject>

-(void)updateTask;

@end


@interface DetailTaskViewController : UIViewController<EditTaskViewControllerDelegate>
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) id<DetailTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) TaskModel *task;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@end
