//
//  ZHAddressErrorTipView.h
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHAddressTextFiledView;
/*!
 展示验证的错误信息
 */
@interface ZHAddressErrorTipView : UIView

/**
 获取当前错误提示试图所在的ZHAddressTextFiledView
 */
@property(nonatomic, strong, readonly) ZHAddressTextFiledView *showInAddressTextFiledView;
/**
 错误提示展示的父试图 解决提示语被遮挡的BUG 如果为nil则自动判断
 */
@property(nonatomic, strong) UIView *errorSuperView;
/*!
 单例 防止全屏幕弹出错误信息 影响用户体验

 @return ZHAddressErrorTipView的单例
 */
+ (instancetype)sharedInstance;

/*!
 展示错误的信息

 @param addressView 展示错误信息的位置试图
 @param errorTipString 错误信息
 */
- (void)showInAddressView:(ZHAddressTextFiledView *)addressView errorTipString:(NSString *)errorTipString;

/*!
 隐藏弹出的错误试图
 */
- (void)hide;

@end
