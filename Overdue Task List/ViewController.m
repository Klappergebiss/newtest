//
//  ViewController.m
//  Overdue Task List
//
//  Created by Tim Engel on 13.11.15.
//  Copyright © 2015 Tim Engel. All rights reserved.
//

#import "ViewController.h"
#import "DetailTaskViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - lazy instantiations

-(NSMutableArray *)tasksArray {
    if (!_tasksArray) {
        _tasksArray = [[NSMutableArray alloc] init];
    }
    
    return _tasksArray;
}

#pragma mark - basics

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSArray *tasksAsPlists = [[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY];
    
    for (NSDictionary *dictionary in tasksAsPlists) {
        TaskModel *taskObject = [self convertDictionaryToTask:dictionary];
        [self.tasksArray addObject:taskObject];
    
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[AddTaskViewController class]]) {
        AddTaskViewController *addTaskVC = segue.destinationViewController;
        addTaskVC.delegate = self;
    }
    else if ([segue.destinationViewController isKindOfClass:[DetailTaskViewController class]]) {
        DetailTaskViewController *detailTaskVC = segue.destinationViewController;
        NSIndexPath *path = sender;
        TaskModel *task = self.tasksArray[path.row];
        detailTaskVC.task = task;
        detailTaskVC.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AddTaskViewControllerDelegate

-(void)didCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(TaskModel *)task{
    [self.tasksArray addObject:task];
    
    NSMutableArray *tasksArrayAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY] mutableCopy];
    if (!tasksArrayAsPropertyLists) tasksArrayAsPropertyLists = [[NSMutableArray alloc] init];
    
    [tasksArrayAsPropertyLists addObject:[self convertTaskToPlist:task]];
    
    [[NSUserDefaults standardUserDefaults] setObject:tasksArrayAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

#pragma mark - Helper methods

-(NSDictionary *)convertTaskToPlist:(TaskModel *)taskObject {
    NSDictionary *dictionary = @{TASK_TITLE : taskObject.title, TASK_DESCRIPTION : taskObject.detailDescription, TASK_DATE : taskObject.date, TASK_COMPLETION : @(taskObject.isCompleted)};
    return dictionary;
}

-(TaskModel *)convertDictionaryToTask:(NSDictionary *)dictionary {
    TaskModel *taskObject = [[TaskModel alloc] initWithData:dictionary];
    return taskObject;
}

-(void)updateCompletionOfTask:(TaskModel *)task forIndexPath:(NSIndexPath *)indexPath {
    [self.tasksArray replaceObjectAtIndex:indexPath.row withObject:task];
    
    NSMutableArray *tasksArrayAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY] mutableCopy];
    
    [tasksArrayAsPropertyLists replaceObjectAtIndex:indexPath.row withObject:[self convertTaskToPlist:task]];
    
    [[NSUserDefaults standardUserDefaults] setObject:tasksArrayAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

-(void)saveTasks {
    NSMutableArray *tasksArrayAsPlist = [[NSMutableArray alloc] init];
    
    for (TaskModel *task in self.tasksArray) {
        [tasksArrayAsPlist addObject:[self convertTaskToPlist:task]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tasksArrayAsPlist forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - IBActions

- (IBAction)createTaskButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskSegue" sender:nil];
}

- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender {
    if (self.tableView.editing) {
        [self saveTasks];
        [self.tableView setEditing:NO animated:YES];
    } else [self.tableView setEditing:YES animated:YES];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tasksArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TaskModel *task = self.tasksArray[indexPath.row];
    cell.textLabel.text = task.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    cell.detailTextLabel.text = stringFromDate;
    
    int timeLeft = [task.date timeIntervalSinceNow];
    
    if (task.isCompleted) {
        cell.backgroundColor = [UIColor greenColor];
    } else if (!task.isCompleted && timeLeft < 0) {
        cell.backgroundColor = [UIColor redColor];
    } else if (!task.isCompleted && timeLeft < 86400) {
        cell.backgroundColor = [UIColor orangeColor];
    } else {
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskModel *task = self.tasksArray[indexPath.row];
    task.isCompleted = !task.isCompleted;
    [self updateCompletionOfTask:task forIndexPath:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tasksArray removeObjectAtIndex:indexPath.row];
        NSMutableArray *tasksArrayAsPlist =[[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY] mutableCopy];
        [tasksArrayAsPlist removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:tasksArrayAsPlist forKey:TASK_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toDetailTaskSegue" sender:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    TaskModel *movedTask = self.tasksArray[sourceIndexPath.row];
    [self.tasksArray removeObjectAtIndex:sourceIndexPath.row];
    [self.tasksArray insertObject:movedTask atIndex:destinationIndexPath.row];
}

#pragma mark - DetailTaskViewControllerDelegate

-(void)updateTask {
    [self saveTasks];
    [self.tableView reloadData];
}
@end
















