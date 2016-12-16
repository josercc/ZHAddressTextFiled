//
//  ZHDefineBlocks.h
//  GearBest
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 GearBest. All rights reserved.
//
#import <UIKit/UIKit.h>
/*!
 验证输入的是否正确

 @param inputText 输入的文本
 @return 如果返回值存在就代表验证失败 否则就代表成功
 */
typedef NSString * (^ATFVValidateInputCorrectComplete)(NSString *inputText);
