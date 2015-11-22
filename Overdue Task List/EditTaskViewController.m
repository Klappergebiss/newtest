//
//  EditTaskViewController.m
//  Overdue Task List
//
//  Created by Tim Engel on 13.11.15.
//  Copyright © 2015 Tim Engel. All rights reserved.
//

#import "EditTaskViewController.h"

@interface EditTaskViewController ()

@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleTextField.text = self.task.title;
    self.descriptionTextView.text = self.task.detailDescription;
    self.datePicker.date = self.task.date;
    
    self.descriptionTextView.delegate = self;
    self.titleTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - helper methods

-(void) updateTask {
    self.task.title = self.titleTextField.text;
    self.task.detailDescription = self.descriptionTextView.text;
    self.task.date = self.datePicker.date;
}

#pragma mark - IBActions

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    [self updateTask];
    [self.delegate didSave];
}

#pragma mark - UITextViewDelegate and UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.titleTextField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.descriptionTextView resignFirstResponder];
        return NO;
    } else return YES;
}

@end
