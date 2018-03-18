//
//  DetialsViewController.m
//  WeekTwoDayThreePointNine
//
//  Created by OurEDA on 2018/3/14.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "DetialsViewController.h"

@interface DetialsViewController ()
@property(strong, nonatomic) NSUserDefaults *myUserDefaults;
@property(strong, nonatomic) NSDictionary *dict;
@property(strong, nonatomic) NSDictionary *result;
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
//    [myBackButton setBackgroundColor:[UIColor yellowColor]];
    [myBackButton setTitle:@"Contacts" forState:UIControlStateNormal];
    [myBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myBackButton];
    UIButton *myEditButton = [[UIButton alloc] initWithFrame:CGRectMake(screen.size.width - 100, 20, 80, 30)];
//    [myFinishButton setBackgroundColor:[UIColor greenColor]];
    [myEditButton setTitle:@"Edit" forState:UIControlStateNormal];
    [myEditButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myEditButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myEditButton];
    self.myUserDefaults = [NSUserDefaults standardUserDefaults];
    //Contacts Detials Follow Up Here

//    NSBundle *bundle=[NSBundle mainBundle];
//    NSString *plistPath=[bundle pathForResource:@"Contacts"ofType:@"plist"];
    self.filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/Contacts.plist"];
    self.sandboxDic = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];
    NSLog(@"sandbixDictionary: %@",self.sandboxDic);
//    self.dict=[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.result = [[NSDictionary alloc] initWithDictionary:[self.sandboxDic objectForKey:self.uuid]];
    NSLog(@"%@", self.result);
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 50, 44)];
//    Name.text=[NSString stringWithFormat:@"%ld",self.index];
    Name.text = @"Name";
    [self.view addSubview:Name];
    UILabel *Email = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 50, 44)];
//    Name.text=[NSString stringWithFormat:@"%ld",self.index];
    Email.text = @"Email";
    [self.view addSubview:Email];
    UILabel *PhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 50, 44)];
//    Name.text=[NSString stringWithFormat:@"%ld",self.index];
    PhoneNumber.text = @"Phone";
    [self.view addSubview:PhoneNumber];
    self.name = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 44)];
    [self.name setTitle:[self.result objectForKey:@"Name"] forState:UIControlStateNormal];
    [self.name setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.name];
    self.email = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 150, 44)];
    [self.email setTitle:[self.result objectForKey:@"Email"] forState:UIControlStateNormal];
    [self.email setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.email];
    self.phoneNumber = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 150, 44)];
    [self.phoneNumber setTitle:[self.result objectForKey:@"PhoneNumber"] forState:UIControlStateNormal];
    [self.phoneNumber setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.phoneNumber];

//    NSLog(@"Name get index: %ld",self.index);

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
    myEditVC.uuid= self.uuid;
    //*********TODO:change Contact info into Contacts.plist***********
    [self.navigationController pushViewController:myEditVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.sandboxDic = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];
    self.result = [[NSDictionary alloc] initWithDictionary:[self.sandboxDic objectForKey:self.uuid]];
    [self.name setTitle:[self.result objectForKey:@"Name"] forState:UIControlStateNormal];
    [self.email setTitle:[self.result objectForKey:@"Email"] forState:UIControlStateNormal];
    [self.phoneNumber setTitle:[self.result objectForKey:@"PhoneNumber"] forState:UIControlStateNormal];
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
