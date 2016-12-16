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

/*!
 单例 防止全屏幕弹出错误信息 影响用户体验

 @return ZHAddressErrorTipView的单例
 */
+ (instancetype)sharedInstance;

///*!
// 需要展示父试图 默认为自己查找 自己查找会出现不显示bug
// */
//@property (nonatomic, strong) UIView *showSuperView;

/*!
 展示错误的信息

 @param addressView 展示错误信息的位置试图
 @param errorTipString 错误信息
 */
- (void)showInAddressView:(ZHAddressTextFiledView *)addressView
           errorTipString:(NSString *)errorTipString;

/*!
 隐藏弹出的错误试图
 */
- (void)hide;

@end
