//
//  ZHAddressTextFiledView.h
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHDefineBlocks.h"
#import "ZHAddressTextFiledViewDataSource.h"
#import "ZHAddressTextFiledViewStyle.h"

@class ZHAddressTextFiledViewStyle;

/*!
 地址栏输入的自定义输入框
 */
@interface ZHAddressTextFiledView : UIView

/*!
 验证输入的字符串是否符合要求 用户自己自定义验证方式 如果返回的字符串存在就代表验证不通过 展示返回的字符串
 */
@property (nonatomic, copy) ATFVValidateInputCorrectComplete validateInputCorrectComplete;

/*!
 设置数据源 用户是否允许输入 还是响应用户其他操作
 */
@property (nonatomic, weak) id<ZHAddressTextFiledViewDataSource> dataSource;
/*!
 输入框的内容 用户可以自己自行设置
 */
@property (nonatomic, copy) NSString *inputText;

/*!
 根据自定义的格式生成输入框

 @param style 格式
 @param frame 试图的大小
 @return ZHAddressTextFiledView
 */
- (ZHAddressTextFiledView *)initWithStyle:(ZHAddressTextFiledViewStyle *)style
                                    frame:(CGRect)frame;

/*!
 是否是这个对象的输入框

 @param textFiled 需要判断的输入框
 @return 如果是YES代表是 如果是NO代表不是
 */
- (BOOL)isEqualTextFiled:(UITextField *)textFiled;

/*!
 更新当前的状态

 @param state 当前的状态
 */
- (void)setEditState:(ATFVEditState)state;

/*!
 失去焦点恢复
 */
- (void)reloadNormalState;

@end
