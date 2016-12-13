//
//  DefineFunction.h
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 数字RGB转换成颜色 数字在0-255之间

 @param red Red的值
 @param green Green的值
 @param blue Blue的值
 @param alpha Alpha的值
 @return UIColor颜色值
 */
static UIColor *ATFVSColorWithRGB(CGFloat red,CGFloat green,CGFloat blue,CGFloat alpha) {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}
