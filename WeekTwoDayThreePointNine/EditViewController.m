//
//  EditViewController.m
//  WeekTwoDayThreePointNine
//
//  Created by OurEDA on 2018/3/14.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController () <UITextFieldDelegate> {
    NSManagedObjectContext *context;
}
@property(strong, nonatomic) NSUserDefaults *myUserDefaults;
@property(strong, nonatomic) UITextField *name;
@property(strong, nonatomic) UITextField *email;
@property(strong, nonatomic) UITextField *phoneNumber;
@property(strong, nonatomic) NSString *home;
@property(strong, nonatomic) NSString *docPath;
@property(strong, nonatomic) NSString *filePath;
@property(strong, nonatomic) NSArray *result;
@property(nonatomic, strong) NSMutableDictionary *sandboxDic;
@property(strong, nonatomic) UIButton *deleteButton;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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

    //screen views
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIButton *myBackButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 80, 30)];
    [myBackButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [myBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myBackButton];
    UIButton *myFinishButton = [[UIButton alloc] initWithFrame:CGRectMake(screen.size.width - 100, 20, 80, 30)];
    [myFinishButton setTitle:@"Finish" forState:UIControlStateNormal];
    [myFinishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myFinishButton addTarget:self action:@selector(finishButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myFinishButton];
    self.myUserDefaults = [NSUserDefaults standardUserDefaults];
    //Contacts Detials Follow Up Here

    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 50, 44)];
    Name.text = @"Name";
    [self.view addSubview:Name];
    UILabel *Email = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 50, 44)];
    Email.text = @"Email";
    [self.view addSubview:Email];
    UILabel *PhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 50, 44)];
    PhoneNumber.text = @"Phone";
    [self.view addSubview:PhoneNumber];
    self.name = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 150, 44)];
    self.name.borderStyle = UITextBorderStyleRoundedRect;
    [self.name setText:[[self.result lastObject] valueForKey:@"name"]];
    self.name.delegate = self;
    [self.view addSubview:self.name];
    self.email = [[UITextField alloc] initWithFrame:CGRectMake(100, 150, 150, 44)];
    [self.email setText:[[self.result lastObject] valueForKey:@"email"]];
    self.email.borderStyle = UITextBorderStyleRoundedRect;
    self.email.delegate = self;
    [self.view addSubview:self.email];
    self.phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 150, 44)];
    [self.phoneNumber setText:[[self.result lastObject] valueForKey:@"tel"]];
    self.phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneNumber.delegate = self;
    [self.view addSubview:self.phoneNumber];
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake((screen.size.width - 80) / 2, 250, 80, 30)];
    [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed:(id)sender {
    NSLog(@"back Button Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishButtonPressed:(id)sender {
    NSLog(@"finish Button Pressed");

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", self.uuid];
    request.predicate = predicate;

    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];
    NSLog(@"name = %@", [[objs lastObject] valueForKey:@"name"]);
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    Person *Contact = [objs lastObject];
    Contact.name = self.name.text;
    Contact.email = self.email.text;
    Contact.tel = self.phoneNumber.text;
    [context updatedObjects];
    if ([context save:&error]) {
        NSLog(@"Succeed!");
    } else {
        [NSException raise:@"修改错误" format:@"%@", [error localizedDescription]];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteButtonPressed:(id)sender {
    NSLog(@"delete Button Pressed");
    UIAlertController *actionSheetController = [[UIAlertController alloc] init];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"tap Cancel Button");
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"tap Delete Button");

        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", self.uuid];
        request.predicate = predicate;

        NSError *error = nil;
        NSArray *objs = [context executeFetchRequest:request error:&error];
        NSLog(@"name = %@", [[objs lastObject] valueForKey:@"name"]);
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        }
        [context deleteObject:[objs lastObject]];

        if ([context save:&error]) {
            NSLog(@"Succeed!");
        } else {
            [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:deleteAction];

    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"TextField get focus.");
    [textField resignFirstResponder];
    return TRUE;
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
