//
//  NewRunViewController.h
//  MyRunner
//
//  Created by Harvey Zhang on 3/31/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 The New Run screen has two modes: pre-run and during-run.
 The VC handles the logic of how each one displays.
 
 
 
 */
@interface NewRunViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
