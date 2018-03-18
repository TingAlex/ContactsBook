//
//  EditViewController.m
//  WeekTwoDayThreePointNine
//
//  Created by OurEDA on 2018/3/14.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()<UITextFieldDelegate>
@property (strong,nonatomic) NSUserDefaults *myUserDefaults;
@property (strong,nonatomic) UITextField *name;
@property (strong,nonatomic) UITextField *email;
@property (strong,nonatomic) UITextField *phoneNumber;
@property (strong,nonatomic) NSString* home;
@property (strong,nonatomic) NSString* docPath;
@property (strong,nonatomic) NSString* filePath;
@property (strong,nonatomic) NSDictionary *result;
@property (nonatomic,strong) NSMutableDictionary *sandboxDic;
@property (strong,nonatomic) UIButton *deleteButton;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //get the dict count in the sandbox
    //    self.home=NSHomeDirectory();
    self.filePath= [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0]stringByAppendingPathComponent:@"/Contacts.plist"];
    //    self.docPath=[self.home stringByAppendingPathComponent:@"Documents"];
    //    self.filePath=[self.docPath stringByAppendingPathComponent:@"Contacts.plist"];
    self.sandboxDic=[NSMutableDictionary dictionaryWithContentsOfFile:self.filePath];
    self.result=[[NSDictionary alloc] initWithDictionary:[self.sandboxDic objectForKey:self.uuid]];
    //screen views
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
    [self.name setText:[self.result objectForKey:@"Name"]];
    self.name.delegate=self;
    [self.view addSubview:self.name];
    self.email=[[UITextField alloc] initWithFrame:CGRectMake(100, 150, 150, 44)];
    [self.email setText:[self.result objectForKey:@"Email"]];
    self.email.borderStyle=UITextBorderStyleRoundedRect;
    self.email.delegate=self;
    [self.view addSubview:self.email];
    self.phoneNumber=[[UITextField alloc] initWithFrame:CGRectMake(100, 200, 150, 44)];
    [self.phoneNumber setText:[self.result objectForKey:@"PhoneNumber"]];
    self.phoneNumber.borderStyle=UITextBorderStyleRoundedRect;
    self.phoneNumber.delegate=self;
    [self.view addSubview:self.phoneNumber];
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake((screen.size.width-80)/2, 250, 80, 30)];
    [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteButton];

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

    NSDictionary *newContact=[[NSDictionary alloc]initWithObjectsAndKeys:self.uuid,@"ID",self.name.text,@"Name",self.phoneNumber.text,@"PhoneNumber",self.email.text,@"Email", nil];
    [self.sandboxDic setValue:newContact forKey:self.uuid];
    NSLog(@"after edit contact:");
    NSLog(@"%@",self.sandboxDic);
    [self.sandboxDic writeToFile:self.filePath atomically:YES];
    //add New Contact into Contacts.plist***********
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) deleteButtonPressed:(id)sender{
    NSLog(@"delete Button Pressed");
    UIAlertController* actionSheetController= [[UIAlertController alloc] init];
    UIAlertAction* cancelAction=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"tap Cancel Button");
    }];
    UIAlertAction* deleteAction=[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        NSLog(@"tap Delete Button");
        [self.sandboxDic removeObjectForKey:self.uuid];
        [self.sandboxDic writeToFile:self.filePath atomically:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:deleteAction];

    [self presentViewController:actionSheetController animated:YES completion:nil];
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
