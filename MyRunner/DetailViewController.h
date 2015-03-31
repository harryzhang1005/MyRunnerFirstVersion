//
//  DetailViewController.h
//  MyRunner
//
//  Created by Harvey Zhang on 3/31/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

