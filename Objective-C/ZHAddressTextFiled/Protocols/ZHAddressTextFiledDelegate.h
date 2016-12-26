//
//  ZHAddressTextFiledDelegate.h
//  Pods
//
//  Created by 张行 on 2016/12/26.
//
//

#import <Foundation/Foundation.h>

@class ZHAddressTextFiledView;

@protocol ZHAddressTextFiledViewDelegate <NSObject>

/**
 点击了输入框的回调 可以自己设置一些事件

 @param view 点击输入框所在的试图
 */
- (void)addressTextFiledViewDidClickTextFiled:(ZHAddressTextFiledView *)view;

@end
