//
//  HomeViewController.m
//  MyRunner
//
//  Created by Harvey Zhang on 3/31/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import "HomeViewController.h"
#import "NewRunViewController.h"
#import "BadgesTableViewController.h"
#import "BadgeController.h"
#import <CoreData/CoreData.h>

@interface HomeViewController ()

@property (nonatomic, strong) NSArray   *runArray; // get the runs and pass them to badges table view controller

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getAllRuns];
}

// Read / get all runs from MyRunner.sqlite
-(void)getAllRuns
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Run"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.runArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *nextVC = [segue destinationViewController];
    if ([nextVC isKindOfClass:[NewRunViewController class]])    // judge using class type or use segue name
    {
        ((NewRunViewController *)nextVC).managedObjectContext = self.managedObjectContext;
        
    } else if ([nextVC isKindOfClass:[BadgesTableViewController class]]) {
        
        ((BadgesTableViewController *)nextVC).earnStatusArray = [[BadgeController defaultController] earnStatusesForRuns:self.runArray];
    }
    
}

@end
