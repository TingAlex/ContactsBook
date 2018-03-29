//
//  EditViewController.h
//  WeekTwoDayThreePointNine
//
//  Created by OurEDA on 2018/3/14.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewContactViewController.h"
#import "Person+CoreDataClass.h"

@interface EditViewController : UIViewController <UITextFieldDelegate>
@property(nonatomic, assign) NSString *uuid;

@end
