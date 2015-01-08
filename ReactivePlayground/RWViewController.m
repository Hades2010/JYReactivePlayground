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
    
    self.nameTextFiled = [[UITextField alloc] initWithFrame:nameTextField];
    self.nameTextFiled.borderStyle = UITextBorderStyleLine;
    [self.nameTextFiled setPlaceholder:@"输入用户名"];
    [self.view addSubview:self.nameTextFiled];
   
    self.passwordTextField = [[UITextField alloc] initWithFrame:passwordTextField];
    self.passwordTextField.borderStyle = UITextBorderStyleLine;
    [self.passwordTextField setPlaceholder:@"输入用户密码"];
    [self.passwordTextField setSecureTextEntry:YES];
    [self.view addSubview:self.passwordTextField];
    
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
        return @([self isValidUsername:text]);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
