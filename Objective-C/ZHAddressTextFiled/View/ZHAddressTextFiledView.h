//
//  ZHAddressTextFiledView.h
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHAddressTextFiledViewStyle;

@interface ZHAddressTextFiledView : UIView

/**
 根据自定义的格式生成输入框

 @param style 格式
 @param frame 试图的大小
 @return ZHAddressTextFiledView
 */
- (ZHAddressTextFiledView *)initWithStyle:(ZHAddressTextFiledViewStyle *)style
                                    frame:(CGRect)frame;

@end
