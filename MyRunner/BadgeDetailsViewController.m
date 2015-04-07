//
//  BadgeDetailsViewController.m
//  MyRunner
//
//  Created by Harvey Zhang on 4/2/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import "BadgeDetailsViewController.h"
#import "BadgeEarnStatus.h"
#import "Badge.h"
#import "MathController.h"
#import "Run.h"
#import "BadgeController.h"
#import "HGDateFormatter.h"


@interface BadgeDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel    *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel    *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel    *earnedLabel;
@property (nonatomic, weak) IBOutlet UILabel    *silverLabel;
@property (nonatomic, weak) IBOutlet UILabel    *goldLabel;
@property (nonatomic, weak) IBOutlet UILabel    *bestLabel;

@property (nonatomic, weak) IBOutlet UIImageView    *badgeImageView;
@property (nonatomic, weak) IBOutlet UIImageView    *silverImageView;
@property (nonatomic, weak) IBOutlet UIImageView    *goldImageView;

@end

@implementation BadgeDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/8);
    
    self.nameLabel.text = self.earnStatus.badge.name;
    self.distanceLabel.text = [MathController stringifyDistance:self.earnStatus.badge.distance];
    self.badgeImageView.image = [UIImage imageNamed:self.earnStatus.badge.imageName];
    self.earnedLabel.text = [NSString stringWithFormat:@"Reached on %@", [[HGDateFormatter sharedDateFormatter] stringFromDate:self.earnStatus.earnRun.timestamp]];
    
    // silver
    if (self.earnStatus.silverRun) {
        self.silverImageView.transform = transform;
        self.silverImageView.hidden = NO;
        self.silverLabel.text = [NSString stringWithFormat:@"Earned on %@", [[HGDateFormatter sharedDateFormatter] stringFromDate:self.earnStatus.silverRun.timestamp]];
    } else {
        self.silverImageView.hidden = YES;
        self.silverLabel.text = [NSString stringWithFormat:@"Pace < %@ for silver!", [MathController stringifyAvgPaceFromDistance:(self.earnStatus.earnRun.distance.floatValue * silverMultiplier) overTime:self.earnStatus.earnRun.duration.intValue]];
    }
    
    // gold
    if (self.earnStatus.goldRun) {
        self.goldImageView.transform = transform;
        self.goldImageView.hidden = NO;
        self.goldLabel.text = [NSString stringWithFormat:@"Earned on %@", [[HGDateFormatter sharedDateFormatter] stringFromDate:self.earnStatus.goldRun.timestamp]];
    } else {
        self.goldImageView.hidden = YES;
        self.goldLabel.text = [NSString stringWithFormat:@"Pace < %@ for gold!", [MathController stringifyAvgPaceFromDistance:(self.earnStatus.earnRun.distance.floatValue * goldMultiplier) overTime:self.earnStatus.earnRun.duration.intValue]];
    }
    
    self.bestLabel.text = [NSString stringWithFormat:@"Best: %@, %@", [MathController stringifyAvgPaceFromDistance:self.earnStatus.bestRun.distance.floatValue overTime:self.earnStatus.bestRun.duration.intValue], [[HGDateFormatter sharedDateFormatter] stringFromDate:self.earnStatus.bestRun.timestamp]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)infoButtonPressed:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.earnStatus.badge.name message:self.earnStatus.badge.msg
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
