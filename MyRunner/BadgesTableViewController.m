//
//  BadgesTableViewController.m
//  MyRunner
//
//  Created by Harvey Zhang on 4/2/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import "BadgesTableViewController.h"
#import "BadgeEarnStatus.h"
#import "BadgeCell.h"
#import "MathController.h"
#import "Run.h"
#import "Badge.h"
#import "BadgeDetailsViewController.h"
#import "HGDateFormatter.h"

@interface BadgesTableViewController ()

@property (nonatomic, strong) UIColor   *redColor;      // no earn badge
@property (nonatomic, strong) UIColor   *greenColor;    // earn badge

@property (nonatomic, assign) CGAffineTransform transform;

@end

@implementation BadgesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.redColor = [UIColor colorWithRed:1.0f green:20/255.0 blue:44/255.0 alpha:1.0f];
    self.greenColor = [UIColor colorWithRed:0.0f green:146/255.0 blue:78/255.0 alpha:1.0f];
    
    self.transform = CGAffineTransformMakeRotation(M_PI/8);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.earnStatusArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BadgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BadgeCell" forIndexPath:indexPath];
    
    BadgeEarnStatus *earnStatus = [self.earnStatusArray objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.silverIV.hidden = (earnStatus.silverRun == nil) ? YES : NO;
    cell.goldIV.hidden = (earnStatus.goldRun == nil) ? YES : NO;
    
    if (earnStatus.earnRun)
    {
        cell.nameLabel.text = earnStatus.badge.name;
        cell.nameLabel.textColor = self.greenColor;
        cell.despLabel.text = [NSString stringWithFormat:@"Earned: %@", [[HGDateFormatter sharedDateFormatter] stringFromDate:earnStatus.earnRun.timestamp]];
        cell.despLabel.textColor = self.greenColor;
        cell.badgeIV.image = [UIImage imageNamed:earnStatus.badge.imageName];
        cell.silverIV.transform = self.transform;
        cell.goldIV.transform = self.transform;
        cell.userInteractionEnabled = YES;
    } else {
        cell.nameLabel.text = @"???";
        cell.nameLabel.textColor = self.redColor;
        cell.despLabel.text = [NSString stringWithFormat:@"Run %@ to Earn", [MathController stringifyDistance:earnStatus.badge.distance]];
        cell.badgeIV.image = [UIImage imageNamed:@"camera.png"];
        cell.userInteractionEnabled = NO; // here invalid user interaction
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[BadgeDetailsViewController class]])
    {
        // indexPathForSelectedRow -- returns nil or index path representing section and row of selection.
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BadgeEarnStatus *earnStatus = [self.earnStatusArray objectAtIndex:indexPath.row];
        [(BadgeDetailsViewController *)[segue destinationViewController] setEarnStatus:earnStatus];
    }
    
}


@end
