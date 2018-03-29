//
//  ViewController.m
//  WeekTwoDayThreePointNine
//
//  Created by OurEDA on 2018/3/14.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "ViewController.h"
#import "NSString+PinYin.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) NSArray *demoArray;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *addContactButton;

@end

@implementation ViewController {
    NSManagedObjectContext *context;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    NSError *error = nil;
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingString:@"Person.sqlite"]];

    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) {
        [NSException raise:@"DB Error" format:@"%@", [error localizedDescription]];
    }

    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;

    //-------------------
//    NSManagedObject *s1 = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
//    [s1 setValue:@"小明" forKey:@"name"];
//    [s1 setValue:@"001" forKey:@"uid"];
//    [s1 setValue:@"ssdut.dlut.edu.cn" forKey:@"email"];
//    [s1 setValue:@"1234235433" forKey:@"tel"];
//
//    if ([context save:&error]) {
//        NSLog(@"Succeed!");
//    } else {
//        [NSException raise:@"插入错误" format:@"%@", [error localizedDescription]];
//    }
//--------------------

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid LIKE '*'"];
    request.predicate = predicate;

    self.demoArray = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    //After sort:
    self.demoArray = [self.demoArray arrayWithPinYinFirstLetterFormat];
    NSLog(@"%@", self.demoArray);

    CGRect screen = [[UIScreen mainScreen] bounds];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, screen.size.width, screen.size.height - 100) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.addContactButton = [[UIButton alloc] initWithFrame:CGRectMake(screen.size.width - 70, 20, 50, 30)];
    [self.addContactButton setTitle:@"New+" forState:UIControlStateNormal];
    [self.addContactButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.addContactButton addTarget:self action:@selector(addContactsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addContactButton];

}

- (void)addContactsButtonPressed:(id)sender {
    NSLog(@"Add Contacts Button was Pressed.");
    NewContactViewController *myNewContactVC = [[NewContactViewController alloc] init];
    [self.navigationController pushViewController:myNewContactVC animated:YES];
}

- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableFlag = @"resuableFlag";

    if (indexPath.section == 0) {
        UserselfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserselfCell"];
        if (cell == nil) {
            cell = [[UserselfCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserselfCell"];
            NSLog(@"______");
        }

        cell.UserShortPicImageView.image = [UIImage imageNamed:@"message.jpg"];
        cell.UserShortPicImageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.UserNameLabel.text = @"Shi Chongzheng";
        cell.UserTelLabel.text = @"18340853573";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableFlag];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableFlag];
            NSLog(@"______");
        }
        NSDictionary *dict = self.demoArray[indexPath.section - 1];
        NSMutableArray *array = dict[@"content"];
        cell.textLabel.text = [[array objectAtIndex:[indexPath row]] valueForKey:@"Name"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.demoArray count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        NSDictionary *dict = self.demoArray[section - 1];
        NSMutableArray *array = dict[@"content"];
        return [array count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        return;
    }
    NSDictionary *dict = self.demoArray[indexPath.section - 1];
    NSMutableArray *array = dict[@"content"];
    DetialsViewController *detial = [[DetialsViewController alloc] initWithNibName:@"DetialsViewController" bundle:nil];
    detial.uuid = [[array objectAtIndex:[indexPath row]] valueForKey:@"uid"];

    NSLog(@"show uuid : %@", detial.uuid);
    [self.navigationController pushViewController:detial animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSError *error = nil;
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingString:@"Person.sqlite"]];

    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) {
        [NSException raise:@"DB Error" format:@"%@", [error localizedDescription]];
    }

    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid LIKE '*'"];
    request.predicate = predicate;

    self.demoArray = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    self.demoArray = [self.demoArray arrayWithPinYinFirstLetterFormat];
    [self.tableView reloadData];
}

#pragma mark---tableView索引相关设置----

//添加TableView头视图标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        NSDictionary *dict = self.demoArray[section - 1];
        NSString *title = dict[@"firstLetter"];
        return title;
    }
}


//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *resultArray = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (NSDictionary *dict in self.demoArray) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    return resultArray;
}


//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
    }
}

@end
