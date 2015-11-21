//
//  AddTaskViewController.h
//  Overdue Task List
//
//  Created by Tim Engel on 13.11.15.
//  Copyright © 2015 Tim Engel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

@protocol AddTaskViewControllerDelegate <NSObject>

-(void)didCancel;

-(void)didAddTask:(TaskModel *)task;

@end

@interface AddTaskViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>

- (IBAction)cancelButtonPressed:(UIButton *)sender;
- (IBAction)addTaskButtonPressed:(UIButton *)sender;

@property (weak, nonatomic) id<AddTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

@end
