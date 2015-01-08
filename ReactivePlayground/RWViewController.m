//
//  RWViewController.m
//  ReactivePlayground
//
//  Created by JinYong on 15-1-8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RWViewController.h"
#import <ReactiveCocoa.h>
@interface RWViewController ()

@property (nonatomic, strong) UITextField *nameTextFiled;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *btnLogin;

typedef void (^RWSignInResponse)(BOOL);

- (void) signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock;
@end

@implementation RWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect  headerFrame = [UIScreen mainScreen].bounds;
    CGFloat textFieldWidth  = 300;
    CGFloat textFieldHeight = 30;
    
    CGRect nameTextField = CGRectMake(headerFrame.size.width/2-textFieldWidth/2, 100, textFieldWidth, textFieldHeight);
    CGRect passwordTextField = CGRectMake(headerFrame.size.width/2-textFieldWidth/2, 150, textFieldWidth, textFieldHeight);
    CGRect loginBtn = CGRectMake(headerFrame.size.width/2-textFieldWidth/2, 220, textFieldWidth, textFieldHeight);
    
    self.nameTextFiled = [[UITextField alloc] initWithFrame:nameTextField];
    self.nameTextFiled.borderStyle = UITextBorderStyleLine;
    [self.nameTextFiled setPlaceholder:@"输入用户名"];
    [self.view addSubview:self.nameTextFiled];
   
    self.passwordTextField = [[UITextField alloc] initWithFrame:passwordTextField];
    self.passwordTextField.borderStyle = UITextBorderStyleLine;
    [self.passwordTextField setPlaceholder:@"输入用户密码"];
    [self.passwordTextField setSecureTextEntry:YES];
    [self.view addSubview:self.passwordTextField];
    
    self.btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLogin setFrame:loginBtn];
    [self.btnLogin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnLogin setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.btnLogin setTitle:@"Login" forState:UIControlStateNormal];
//    [self.btnLogin addTarget:self action:@selector(actionLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLogin];
    
//    [[self.nameTextFiled.rac_textSignal filter:^BOOL(id value) {
//        NSString *text = value;
//        return text.length > 3;
//    }] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
//    RACSignal *nameSourceSignal = self.nameTextFiled.rac_textSignal;
//    RACSignal *filterUsername = [nameSourceSignal filter:^BOOL(id value) {
//        NSString *text = value;
//        return text.length > 4;
//    }];
//    [filterUsername subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
//    [[[self.nameTextFiled.rac_textSignal map:^id(NSString *text) {
//        return @(text.length);
//    }]
//      filter:^BOOL(NSNumber *length) {
//          return [length intValue] > 3;
//      }]
//     subscribeNext:^(id x) {
//         NSLog(@"%@",x);
//     }];

    RACSignal *validUsernameSignal = [self.nameTextFiled.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
//    [[validPasswordSignal map:^id(NSNumber *passwordValid) {
//        return [passwordValid boolValue]?[UIColor clearColor]:[UIColor blueColor];
//    }] subscribeNext:^(UIColor *color) {
//        self.passwordTextField.backgroundColor = color;
//    }];
    
    RAC(self.passwordTextField,backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue]?[UIColor clearColor]:[UIColor blueColor];
    }];

    RAC(self.nameTextFiled,backgroundColor) = [validUsernameSignal map:^id(NSNumber *nameVaild) {
        return [nameVaild boolValue]?[UIColor clearColor]:[UIColor blueColor];
    }];
    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal] reduce:^id(NSNumber *usernameVaild,NSNumber *passwordVaild){
        return @([usernameVaild boolValue] && [passwordVaild boolValue]);
    }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signUpActive) {
        self.btnLogin.enabled = [signUpActive boolValue];
    }];
    
    [[self.btnLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"btnLogin clicked");
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (BOOL)isValidUsername:(NSString *)username{
    if (username != nil && username.length > 3) {
        return YES;
    }
    return NO;
}

- (BOOL)isValidPassword:(NSString *)password{
    if (password != nil && password.length > 6) {
        return YES;
    }
    return NO;
}

//- (IBAction)actionLogin:(id)sender{
//    NSLog(@">>>>>>>>>>登录");
//}

- (RACSignal *)signInSignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self signInWithUsername:self.nameTextFiled.text password:self.passwordTextField.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
//    [self performSegueWithIdentifier:@"" sender:self];
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
