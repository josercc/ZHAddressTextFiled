//
//  ViewController.m
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import "ViewController.h"
#import "ZHAddressTextFiled.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZHAddressTextFiledViewStyle *style = [[ZHAddressTextFiledViewStyle alloc] init];
    style.inputPromptText = @"First Name:";
    style.errorTipText = @"First Name length must be greater than or equal to 2 characters";
    ZHAddressTextFiledView *addressView = [[ZHAddressTextFiledView alloc] initWithStyle:style frame:CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    [self.view addSubview:addressView];

    ZHAddressTextFiledViewStyle *style1 = [[ZHAddressTextFiledViewStyle alloc] init];
    style1.inputPromptText = @"First Name:";
    style1.inputAddressText = @"Andy";
    style1.editState = ATFVEditStateEdited;
    ZHAddressTextFiledView *addressView1 = [[ZHAddressTextFiledView alloc] initWithStyle:style1 frame:CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    [self.view addSubview:addressView1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
