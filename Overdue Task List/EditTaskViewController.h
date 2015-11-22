//
//  EditTaskViewController.h
//  Overdue Task List
//
//  Created by Tim Engel on 13.11.15.
//  Copyright © 2015 Tim Engel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

@protocol EditTaskViewControllerDelegate <NSObject>

-(void)didSave;

@end

@interface EditTaskViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) id<EditTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) TaskModel *task;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
