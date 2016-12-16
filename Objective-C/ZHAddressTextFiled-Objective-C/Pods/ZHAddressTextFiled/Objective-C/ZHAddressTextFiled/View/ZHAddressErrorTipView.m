//
//  ZHAddressErrorTipView.m
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import "ZHAddressErrorTipView.h"
#import "ZHDefineFunction.h"
#import "Masonry.h"
#import "ZHAddressTextFiledView.h"

@interface ZHAddressErrorTipView ()

/*!
 错误提示的图标
 */
@property (nonatomic, strong) UIImageView *errorTipImageView;
/*!
 显示三角符号
 */
@property (nonatomic, strong) UIImageView *triangleImageView;
/*!
 显示错误的提示语
 */
@property (nonatomic, strong) UILabel *errorTipLabel;

@end

@implementation ZHAddressErrorTipView {
    CGFloat _maxErrorTipWidth; // 最大提示的宽度 让程序进行自动的计算
}

+ (instancetype)sharedInstance{
    static ZHAddressErrorTipView* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZHAddressErrorTipView alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _maxErrorTipWidth = [UIScreen mainScreen].bounds.size.width - 60; // 默认最大的显示宽度为屏幕的宽度减去60
        self.userInteractionEnabled = NO;
        [self AETVAddSubViews];
        [self AETVAutoLayouts];
    }
    return self;
}

#pragma mark - 布局
/*!
 添加子试图
 */
- (void)AETVAddSubViews {
    [self addSubview:self.errorTipImageView];
    [self addSubview:self.triangleImageView];
    [self addSubview:self.errorTipLabel];
}

/*!
 设置约束
 */
- (void)AETVAutoLayouts {
    [self.errorTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    [self.triangleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.errorTipImageView.mas_bottom);
        make.centerX.equalTo(self.errorTipImageView);
        make.size.mas_equalTo(CGSizeMake(5, 5));
    }];
    [self.errorTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(self.triangleImageView.mas_bottom).offset(-2);
    }];
    
}

#pragma mark - 展示错误信息
- (void)showInAddressView:(ZHAddressTextFiledView *)addressView errorTipString:(NSString *)errorTipString {
    NSParameterAssert(addressView); // 展示错误信息的父试图必须存在
    NSParameterAssert(errorTipString.length > 0); // 展示的内容长度必须大于0
    ZHAddressTextFiledView *oldSuperView = (ZHAddressTextFiledView *)self.superview; // 获取错误试图之前的父试图
    if (oldSuperView) {
        [oldSuperView reloadNormalState]; // 如果有就改变之前父试图的状态
    }
    [self errorBiggestError:addressView];
    self.errorTipLabel.text = errorTipString;
    CGSize size = [self.errorTipLabel sizeThatFits:CGSizeMake(_maxErrorTipWidth, CGFLOAT_MAX)];
    CGFloat width = size.width <= 17 ? 17 : size.width + 10;
    CGFloat height = 17 + 3 + size.height;
    UIView *view = addressView;
    [view addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(view);
        make.top.equalTo(view.mas_bottom).offset(-25);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
}

/*!
 计算当前试图最大展示错误的宽度

 @param addressView 展示错误的试图
 */
- (void)errorBiggestError:(ZHAddressTextFiledView *)addressView {
    UIView *view = addressView.superview; // 获取展示试图的父试图
    BOOL stopLoop = NO; // 是否停止查找
    while (!stopLoop) {
        if (!view) {
            stopLoop = YES; // 如果父试图不存在就停止查找
            continue;
        }else if(CGRectGetWidth(view.frame) == [UIScreen mainScreen].bounds.size.width) {
            // 查找如果父试图宽度是整个屏幕的宽度 停止查找
            stopLoop = YES;
            break;
        }
        view = view.superview;
    }
    if (view) {
        CGRect frame = [addressView convertRect:addressView.bounds toView:view]; // 获取展示试图在查找父试图所在的位置
        _maxErrorTipWidth = CGRectGetMaxX(frame) - 40; // 获取最大展示错误的宽度
    }


}

- (void)hide {
    [self removeFromSuperview]; // 移除错误试图
}

#pragma mark - Getter
- (UIImageView *)errorTipImageView {
	if (_errorTipImageView == nil) {
        _errorTipImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _errorTipImageView.image = [UIImage imageNamed:@"ATF_tip"];

	}
	return _errorTipImageView;
}

- (UIImageView *)triangleImageView {
	if (_triangleImageView == nil) {
        _triangleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _triangleImageView.image = [UIImage imageNamed:@"aTF_Triangle"];
	}
	return _triangleImageView;
}

- (UILabel *)errorTipLabel {
	if (_errorTipLabel == nil) {
        _errorTipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _errorTipLabel.backgroundColor = ATFVSColorWithRGB(243, 120, 0, 1.0);
        _errorTipLabel.textColor = ATFVSColorWithRGB(255, 254, 254, 1.0);
        _errorTipLabel.font = [UIFont systemFontOfSize:10];
        _errorTipLabel.layer.masksToBounds = YES;
        _errorTipLabel.layer.cornerRadius = 2;
        _errorTipLabel.textAlignment = NSTextAlignmentCenter;
        _errorTipLabel.numberOfLines = 0;
	}
	return _errorTipLabel;
}

@end
