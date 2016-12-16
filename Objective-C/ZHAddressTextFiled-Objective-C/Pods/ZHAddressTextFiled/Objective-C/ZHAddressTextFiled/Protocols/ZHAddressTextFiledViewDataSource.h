//
//  ZHAddressTextFiledViewDataSource.h
//  GearBest
//
//  Created by 张行 on 2016/12/14.
//  Copyright © 2016年 GearBest. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZHAddressTextFiledView;

/*!
 ZHAddressTextFiledView数据源
 */
@protocol ZHAddressTextFiledViewDataSource <NSObject>

/*!
 是否允许输入框可以编辑

 @param view 输入框试图对象
 @return 如果不实现 默认是YES是允许输入的
 */
- (BOOL)shouldAllowTextFiledEdit:(ZHAddressTextFiledView *)view;

@end
