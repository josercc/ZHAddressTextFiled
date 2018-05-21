//
//  ViewController.m
//  ZHAddressTextFiled Example
//
//  Created by 张行 on 2018/5/11.
//  Copyright © 2018年 张行. All rights reserved.
//

#import "ViewController.h"
#import "ZHAddressTextFiled.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZHAddressTextFiledViewStyle *style = [[ZHAddressTextFiledViewStyle alloc] init];
    style.inputPromptText = @"这是占位符";
    style.errorTipText = @"错误提示语呀!";
    ZHAddressTextFiledView *addressView = [[ZHAddressTextFiledView alloc] initWithStyle:style frame:CGRectMake(100, 100, 100, 40)];
    [self.view addSubview:addressView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
