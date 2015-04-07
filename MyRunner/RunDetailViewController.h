//
//  DetailViewController.h
//  MyRunner
//
//  Created by Harvey Zhang on 3/31/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Run;

/*
 The user sees a map of their route, along with other details that relate to a specific run.
 
 Note: The app is using Background Modes (Location Updates). So if the app goes in the App Store, you'll have to attach this disclaimer to your app's description: "Continued use of GPS running in the background can dramatically decrease battery life."
 
 ## Revealing the Map
 
 
 */
@interface RunDetailViewController : UIViewController

@property (nonatomic, strong) Run *run;

@end

