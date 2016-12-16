//
//  ZHAddressTextFiledViewStyle.m
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import "ZHAddressTextFiledViewStyle.h"
#import "ZHDefineFunction.h"

@implementation ZHAddressTextFiledViewStyle

- (instancetype)init {
    if (self = [super init]) {
        _inputPromptNormalColor = ATFVSColorWithRGB(153, 153, 153, 1.0);
        _inputPromptHighlightColor = ATFVSColorWithRGB(243, 120, 0, 1.0);
        _inputAddressFiledTextColor = ATFVSColorWithRGB(51, 51, 51, 1.0);
        _bottomLineNormalColor = ATFVSColorWithRGB(222, 222, 222, 1.0);
        _inputPromptLabelFont = [UIFont systemFontOfSize:11];
        _inputAddressFiledFont = [UIFont systemFontOfSize:14];
        _bottomLineHeight = 1.0 / [UIScreen mainScreen].scale;
        _editState = ATFVEditStateNormal;
        _requiredInput = YES;
    }
    return self;
}

@end
