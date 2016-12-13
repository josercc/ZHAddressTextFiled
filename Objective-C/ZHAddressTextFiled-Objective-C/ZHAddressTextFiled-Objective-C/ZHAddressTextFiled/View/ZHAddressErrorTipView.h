//
//  ZHAddressErrorTipView.h
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHAddressTextFiledView;
/**
 展示错误信息
 */
@interface ZHAddressErrorTipView : UIView

+ (instancetype)sharedInstance;

/**
 展示错误的信息

 @param addressView 展示错误信息的位置试图
 @param errorTipString 错误信息
 */
- (void)showInAddressView:(ZHAddressTextFiledView *)addressView
           errorTipString:(NSString *)errorTipString;

- (void)hide;

@end
