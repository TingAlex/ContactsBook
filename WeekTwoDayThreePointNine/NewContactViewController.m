//
//  NewContactViewController.m
//  WeekTwoDayThreePointNine
//
//  Created by OurEDA on 2018/3/14.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "NewContactViewController.h"

@interface NewContactViewController () <UITextFieldDelegate> {
    NSManagedObjectContext *context;
}
@property(strong, nonatomic) UITextField *name;
@property(strong, nonatomic) UITextField *email;
@property(strong, nonatomic) UITextField *phoneNumber;

@end

@implementation NewContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    self.name.delegate = self;
    [self.view addSubview:self.name];
    self.email = [[UITextField alloc] initWithFrame:CGRectMake(100, 150, 150, 44)];
    self.email.borderStyle = UITextBorderStyleRoundedRect;
    self.email.delegate = self;
    [self.view addSubview:self.email];
    self.phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 150, 44)];
    self.phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneNumber.delegate = self;
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

- (void)finishButtonPressed:(id)sender {
    NSLog(@"finish Button Pressed");
    NSString *uuid = [NSUUID UUID].UUIDString;

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

    NSManagedObject *s1 = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    [s1 setValue:self.name.text forKey:@"name"];
    [s1 setValue:uuid forKey:@"uid"];
    [s1 setValue:self.email.text forKey:@"email"];
    [s1 setValue:self.phoneNumber.text forKey:@"tel"];
    if ([context save:&error]) {
        NSLog(@"Succeed!");
    } else {
        [NSException raise:@"插入错误" format:@"%@", [error localizedDescription]];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
