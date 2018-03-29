//
//  DetialsViewController.m
//  WeekTwoDayThreePointNine
//
//  Created by OurEDA on 2018/3/14.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "DetialsViewController.h"

@interface DetialsViewController () {
    NSManagedObjectContext *context;
}
@property(strong, nonatomic) NSUserDefaults *myUserDefaults;
@property(strong, nonatomic) NSDictionary *dict;
@property(strong, nonatomic) NSArray *result;
@property(nonatomic, strong) NSMutableDictionary *sandboxDic;
@property(nonatomic, strong) NSString *filePath;
@property(nonatomic, strong) UIButton *name;
@property(nonatomic, strong) UIButton *email;
@property(nonatomic, strong) UIButton *phoneNumber;

@end

@implementation DetialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIButton *myBackButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 80, 30)];
    [myBackButton setTitle:@"Contacts" forState:UIControlStateNormal];
    [myBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myBackButton];
    UIButton *myEditButton = [[UIButton alloc] initWithFrame:CGRectMake(screen.size.width - 100, 20, 80, 30)];
    [myEditButton setTitle:@"Edit" forState:UIControlStateNormal];
    [myEditButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myEditButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myEditButton];
    self.myUserDefaults = [NSUserDefaults standardUserDefaults];
    //Contacts Detials Follow Up Here

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

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", self.uuid];
    request.predicate = predicate;

    self.result = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }

    NSLog(@"%@", self.result.lastObject);
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 50, 44)];
    Name.text = @"Name";
    [self.view addSubview:Name];
    UILabel *Email = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 50, 44)];
    Email.text = @"Email";
    [self.view addSubview:Email];
    UILabel *PhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 50, 44)];
    PhoneNumber.text = @"Phone";
    [self.view addSubview:PhoneNumber];
    self.name = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 44)];
    [self.name setTitle:[[self.result lastObject] valueForKey:@"name"] forState:UIControlStateNormal];
    [self.name setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.name];
    self.email = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 150, 44)];
    [self.email setTitle:[[self.result lastObject] valueForKey:@"email"] forState:UIControlStateNormal];
    [self.email setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.email];
    self.phoneNumber = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 150, 44)];
    [self.phoneNumber setTitle:[[self.result lastObject] valueForKey:@"tel"] forState:UIControlStateNormal];
    [self.phoneNumber setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.phoneNumber];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed:(id)sender {
    NSLog(@"back Button Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonPressed:(id)sender {
    NSLog(@"edit Button Pressed");
    EditViewController *myEditVC = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
    myEditVC.uuid = self.uuid;
    [self.navigationController pushViewController:myEditVC animated:YES];
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

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", self.uuid];
    request.predicate = predicate;

    self.result = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }

    [self.name setTitle:[[self.result lastObject] valueForKey:@"name"] forState:UIControlStateNormal];
    [self.email setTitle:[[self.result lastObject] valueForKey:@"tel"] forState:UIControlStateNormal];
    [self.phoneNumber setTitle:[[self.result lastObject] valueForKey:@"email"] forState:UIControlStateNormal];
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
