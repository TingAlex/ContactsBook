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
@property(strong, nonatomic) NSUserDefaults *myUserDefaults;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *addContactButton;
@property(nonatomic, strong) NSDictionary *dict;
@property(nonatomic, strong) NSMutableDictionary *sandboxDic;
@property(nonatomic, strong) NSString *filePath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"Contacts" ofType:@"plist"];
    self.dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
            stringByAppendingPathComponent:@"/Contacts.plist"];
    //将工程中的数据新字典写入沙盒
    [self.dict writeToFile:self.filePath atomically:YES];
    self.sandboxDic = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];
//    NSLog(@"sandbox:");
//    NSLog(@"%@",sandboxDic);
//    NSLog(@"%@",self.dict.allValues);
    self.demoArray = [self.sandboxDic allValues];
    NSLog(@"%@", self.demoArray);
    self.demoArray = [self.demoArray arrayWithPinYinFirstLetterFormat];
    NSLog(@"%@", self.demoArray);
//    self.demoArray=[NSArray arrayWithContentsOfFile:plistPath];
//    NSLog(@"%@",[[self.dict objectForKey:self.demoArray[0]] objectForKey:@"Name"]);
    self.myUserDefaults = [NSUserDefaults standardUserDefaults];
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
//    for (int i = 0; i < 10; i++) {
//        NSString *uuid = [NSUUID UUID].UUIDString;
//        NSLog(@"uuid= %@", uuid);
//    }

}

- (void)addContactsButtonPressed:(id)sender {
    NSLog(@"Add Contacts Button was Pressed.");
    NewContactViewController *myNewContactVC = [[NewContactViewController alloc] init];
    [self.navigationController pushViewController:myNewContactVC animated:YES];
}

//*****************Changed*********************
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
        cell.textLabel.text = [[array objectAtIndex:[indexPath row]] objectForKey:@"Name"];
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
//    return [self.demoArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        return;
    }
    NSDictionary *dict = self.demoArray[indexPath.section - 1];
    NSMutableArray *array = dict[@"content"];
    DetialsViewController *detial = [[DetialsViewController alloc] initWithNibName:@"DetialsViewController" bundle:nil];
    detial.uuid = [[array objectAtIndex:[indexPath row]] objectForKey:@"ID"];
//    NSInteger selectedIndex = [indexPath row];
//    detial.uuid= [[self.demoArray objectAtIndex:selectedIndex] objectForKey:@"ID"];
    NSLog(@"show uuid : %@", detial.uuid);
    [self.navigationController pushViewController:detial animated:YES];
//    NSLog(@"selected index: %ld",selectedIndex+1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.sandboxDic = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];
    self.demoArray = [self.sandboxDic allValues];
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
