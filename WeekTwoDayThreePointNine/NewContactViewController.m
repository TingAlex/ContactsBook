//
//  NewContactViewController.m
//  WeekTwoDayThreePointNine
//
//  Created by OurEDA on 2018/3/14.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "NewContactViewController.h"

@interface NewContactViewController ()<UITextFieldDelegate>
@property (strong,nonatomic) NSUserDefaults *myUserDefaults;
@property (strong,nonatomic) NSMutableDictionary *dict;
@property (strong,nonatomic) UITextField *name;
@property (strong,nonatomic) UITextField *email;
@property (strong,nonatomic) UITextField *phoneNumber;
@property (strong,nonatomic) NSString* home;
@property (strong,nonatomic) NSString* docPath;
@property (strong,nonatomic) NSString* filePath;
@end

@implementation NewContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect screen=[[UIScreen mainScreen] bounds];
    UIButton *myBackButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 80, 30)];
    //    [myBackButton setBackgroundColor:[UIColor yellowColor]];
    [myBackButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [myBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myBackButton];
    UIButton *myFinishButton = [[UIButton alloc] initWithFrame:CGRectMake(screen.size.width-100, 20, 80, 30)];
    //    [myFinishButton setBackgroundColor:[UIColor greenColor]];
    [myFinishButton setTitle:@"Finish" forState:UIControlStateNormal];
    [myFinishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myFinishButton addTarget:self action:@selector(finishButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myFinishButton];
    self.myUserDefaults=[NSUserDefaults standardUserDefaults];
    //Contacts Detials Follow Up Here

    UILabel *Name=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, 50, 44)];
    //    Name.text=[NSString stringWithFormat:@"%ld",self.index];
    Name.text=@"Name";
    [self.view addSubview:Name];
    UILabel *Email=[[UILabel alloc] initWithFrame:CGRectMake(20, 150, 50, 44)];
    //    Name.text=[NSString stringWithFormat:@"%ld",self.index];
    Email.text=@"Email";
    [self.view addSubview:Email];
    UILabel *PhoneNumber=[[UILabel alloc] initWithFrame:CGRectMake(20, 200, 50, 44)];
    //    Name.text=[NSString stringWithFormat:@"%ld",self.index];
    PhoneNumber.text=@"Phone";
    [self.view addSubview:PhoneNumber];
    self.name=[[UITextField alloc] initWithFrame:CGRectMake(100, 100, 150, 44)];
    self.name.borderStyle=UITextBorderStyleRoundedRect;
    self.name.delegate=self;
    [self.view addSubview:self.name];
    self.email=[[UITextField alloc] initWithFrame:CGRectMake(100, 150, 150, 44)];
    self.email.borderStyle=UITextBorderStyleRoundedRect;
    self.email.delegate=self;
    [self.view addSubview:self.email];
    self.phoneNumber=[[UITextField alloc] initWithFrame:CGRectMake(100, 200, 150, 44)];
    self.phoneNumber.borderStyle=UITextBorderStyleRoundedRect;
    self.phoneNumber.delegate=self;
    [self.view addSubview:self.phoneNumber];
    //get the dict count in the sandbox
//    self.home=NSHomeDirectory();
    self.filePath= [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0]stringByAppendingPathComponent:@"/Contacts.plist"];
//    self.docPath=[self.home stringByAppendingPathComponent:@"Documents"];
//    self.filePath=[self.docPath stringByAppendingPathComponent:@"Contacts.plist"];
    self.dict=[NSMutableDictionary dictionaryWithContentsOfFile:self.filePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) backButtonPressed:(id)sender{
    NSLog(@"back Button Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) finishButtonPressed:(id)sender{
    //***********No Check,Not SAFE!!!**************
    NSLog(@"finish Button Pressed");
    NSString *uuid=[NSUUID UUID].UUIDString;
    NSDictionary *newContact=[[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"ID",self.name.text,@"Name",self.phoneNumber.text,@"PhoneNumber",self.email.text,@"Email", nil];

    [self.dict setValue:newContact forKey:uuid];
    NSLog(@"after add new contact:");
    NSLog(@"%@",self.dict);
    [self.dict writeToFile:self.filePath atomically:YES];
    //add New Contact into Contacts.plist***********
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
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
