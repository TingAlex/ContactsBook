//
//  AppDelegate.h
//  WeekTwoDayThreePointNine
//
//  Created by OurEDA on 2018/3/14.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewController.h"
#import "NewContactViewController.h"
#import "EditViewController.h"
#import "DetialsViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong,nonatomic) UINavigationController *viewController;
- (void)saveContext;


@end

