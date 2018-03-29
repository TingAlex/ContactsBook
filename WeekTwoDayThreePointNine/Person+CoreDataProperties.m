//
//  Person+CoreDataProperties.m
//  WeekTwoDayThreePointNine
//
//  Created by OurEDA on 2018/3/29.
//  Copyright © 2018年 OurEDA. All rights reserved.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic name;
@dynamic tel;
@dynamic uid;
@dynamic email;

@end
