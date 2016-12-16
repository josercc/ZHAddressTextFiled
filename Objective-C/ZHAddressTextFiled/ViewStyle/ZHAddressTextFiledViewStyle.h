//
//  ZHAddressTextFiledViewStyle.h
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHDefineBlocks.h"


/*!
 当前输入框的状态

 - ATFVEditStateNormal: 默认 还没有输入任何的文字
 - ATFVEditStateEditing: 正在进行输入
 - ATFVEditStateEdited: 输入完毕
 - ATFVEditStateEditedError: 输入完毕错误
 */
typedef NS_ENUM(NSUInteger, ATFVEditState) {
    ATFVEditStateNormal,
    ATFVEditStateEditing,
    ATFVEditStateEdited,
    ATFVEditStateEditedError
};

/*!
 设置地址输入框的样式
 */
@interface ZHAddressTextFiledViewStyle : NSObject

#pragma mark - 设置颜色
/*!
 输入提示文字正常显示颜色 默认为153，153，153
 */
@property (nonatomic, strong) UIColor *inputPromptNormalColor;
/*!
 提示输入文字高亮显示的颜色 默认为243，120，0
 */
@property (nonatomic, strong) UIColor *inputPromptHighlightColor;
/*!
 地址输入框的文本颜色 默认为51，51，51
 */
@property (nonatomic, strong) UIColor *inputAddressFiledTextColor;
/*!
 底部分割线默认状态的颜色 222，222，222
 */
@property (nonatomic, strong) UIColor *bottomLineNormalColor;

#pragma mark - 设置字体大小
/*!
 设置提示文字的字体大小 默认为11
 */
@property (nonatomic, strong) UIFont *inputPromptLabelFont;
/*!
 设置输入框字体的大小 默认为14
 */
@property (nonatomic, strong) UIFont *inputAddressFiledFont;

#pragma mark - 设置大小
/*!
 底部分割线的高度 默认为最小的像素
 */
@property (nonatomic, assign) CGFloat bottomLineHeight;

#pragma mark - 设置状态
/*!
 当前输入的状态 默认为ATFVEditStateNormal
 */
@property (nonatomic, assign) ATFVEditState editState;

#pragma mark - 数据源
/*!
 提示文字 默认为nil
 */
@property (nonatomic, copy) NSString *inputPromptText;
/*!
 输入的文本 默认为nil
 */
@property (nonatomic, copy) NSString *inputAddressText;
/*!
 错误的提示 如果为空就不提示
 */
@property (nonatomic, copy) NSString *errorTipText;

/*!
 必填项 默认为YES
 */
@property (nonatomic, assign) BOOL requiredInput;

/*!
 当前的标识
 */
@property (nonatomic, assign) NSUInteger tag;

/*!
 验证输入字符串是否符合规定
 */
@property (nonatomic, copy) ATFVValidateInputCorrectComplete  validateInputCorrectComplete;

@end
