//
//  ZHAddressTextFiledView.m
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import "ZHAddressTextFiledView.h"
#import "ZHAddressTextFiledViewStyle.h"
#import "Masonry.h"
#import "ZHAddressErrorTipView.h"
#import "NSBundle+ZHAddressTextFiled.h"


@interface ZHAddressTextFiledView ()<UITextFieldDelegate>

/*!
 输入提示
 */
@property (nonatomic, strong) UILabel *inputPromptTitleLabel;
/*!
 输入信息的输入框
 */
@property (nonatomic, strong) UITextField *inputTextFiled;
/*!
 底部的分割线
 */
@property (nonatomic, strong) UIView *bottomLineView;


@end

@implementation ZHAddressTextFiledView {
    ZHAddressTextFiledViewStyle *_style; // 当前输入框的样式
    BOOL _isAllowEdit; // 是否允许编辑
}

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // 移除界面所有的通知
}

#pragma mark - Init
- (ZHAddressTextFiledView *)initWithStyle:(ZHAddressTextFiledViewStyle *)style
                                    frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _style = style;
        _isAllowEdit = YES; // 默认允许编辑
        self.backgroundColor = [UIColor whiteColor];
        [self ATFV_InitState]; // 初始化状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    }
    return self;
}

- (void)ATFV_InitState {
    [self ATFVAddSubViews];
    [self ATFVAutoLayouts];
    [self ATFVStepStyle];
}

/*!
 查找的输入框是否是当前界面的输入框

 @param textFiled 查找的输入框
 @return 如果是YES代表是 如果是NO代表不是
 */
- (BOOL)isEqualTextFiled:(UITextField *)textFiled {
    return [self.inputTextFiled isEqual:textFiled];
}

#pragma mark - 键盘即将弹出
/*!
 输入框开始编辑开始

 @param notication 通知
 */
- (void)beginEditingNotification:(NSNotification *)notication {
    ZHAddressTextFiledView *errorTipSuperView = (ZHAddressTextFiledView *)[ZHAddressErrorTipView sharedInstance].superview;
    if (errorTipSuperView && [errorTipSuperView isEqualTextFiled:notication.object]) {
        // 如果错误试图父试图存在 并且正在编辑的是正在展示错误的试图 移除错误提示
        [[ZHAddressErrorTipView sharedInstance] hide];
    }else if(!_isAllowEdit){
        // 如果是不允许用户编辑 如果当前没内容就恢复默认 如果有内容就设置结束状态
        [self setEditState:_style.inputAddressText.length > 0 ? ATFVEditStateEdited : ATFVEditStateNormal];
    }
}

/*!
 输入框结束编辑

 @param notication 通知
 */
- (void)endEditingNotification:(NSNotification *)notication {
    if ([self.inputTextFiled isEqual:notication.object]) {
        // 如果当前界面的输入框等于结束编辑的输入框 保存编辑框的内容 让之前的界面状态结束
        _style.inputAddressText = self.inputTextFiled.text;
        [self setEditState:ATFVEditStateEdited];
    }
}

/*!
 让用户自动调用回复默认状态
 */
- (void)reloadNormalState {
    if (_style.inputAddressText.length == 0) {
        // 只有在没有输入内容的时候才允许恢复默认
        [self setEditState:ATFVEditStateNormal];
    }
}

/*!
 更新当前的状态

 @param state 当前的状态
 */
- (void)setEditState:(ATFVEditState)state {
    NSString *errorMsg; // 错误的提示信息
    BOOL isMovePromptTop = NO; // 是否允许移动提示语到顶部 默认不允许
    if (state == ATFVEditStateEditing || _style.inputAddressText.length > 0) {
        // 如果当前正在编辑 或者输入框内容有值 强制让提示语到顶部
        isMovePromptTop = YES;
    }
    if (self.validateInputCorrectComplete) {
        errorMsg = self.validateInputCorrectComplete(_style.inputAddressText); // 获取用户验证错误的提示语
    }
    if (state == ATFVEditStateEdited) {
        // 只有当前是编辑完成状态 才进行错误提示 或者其他状态恢复
        if (!_style.inputAddressText || !_style.requiredInput) {
            // 如果输入内容不存在 或者 当前的不必须输入 就恢复默认状态
            state = ATFVEditStateNormal;
        }else if(errorMsg && _style.requiredInput == YES){
            // 如果错误内容存在 并且必须输入 就提示错误信息
            state = ATFVEditStateEditedError;
        }
    }
    _style.editState = state;
    // 设置提示语的位置 恢复原来的位置 或者 移动到顶部
    [UIView animateWithDuration:0.25 animations:^{
        [self.inputPromptTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            if (isMovePromptTop) {
                make.top.mas_offset(5);
            }else {
                make.bottom.mas_offset(self->_style.bottomLineHeight);
                make.height.mas_equalTo(33);
            }
        }];
    }];
    // 设置提示语的颜色 如果正在编辑高亮  结束就恢复默认的颜色
    self.inputPromptTitleLabel.textColor = _style.editState == ATFVEditStateEditing ? _style.inputPromptHighlightColor : _style.inputPromptNormalColor;
    // 设置提示语的大小 只有恢复原来位置字体和输入框字体大小一致 不然恢复原来的字体
    self.inputPromptTitleLabel.font = !isMovePromptTop ? _style.inputPromptLabelFont : _style.inputAddressFiledFont;
    // 设置分割线的颜色 正在编辑高亮分割线
    self.bottomLineView.backgroundColor = _style.editState != ATFVEditStateEditing ? _style.bottomLineNormalColor : _style.inputAddressFiledTextColor;
    // 设置输入法是否隐藏
    self.inputTextFiled.hidden = _style.editState == ATFVEditStateNormal;
    // 是否隐藏错误提示
    if (state == ATFVEditStateEditedError) {
        [[ZHAddressErrorTipView sharedInstance] showInAddressView:self errorTipString:errorMsg];
    }
}

#pragma mark - 移动提示文本到顶部
- (void)movePromptToTop {
    if (_style.editState != ATFVEditStateNormal) {
        // 如果当前的状态不是默认 就允许继续操作
        return;
    }

    if (self.dataSource && [self.dataSource respondsToSelector:@selector(shouldAllowTextFiledEdit:)]) {
        _isAllowEdit = [self.dataSource shouldAllowTextFiledEdit:self]; // 获取是否允许编辑
    }
    if (_isAllowEdit) {
        // 只有允许编辑 才可以设置当前状态为可编辑
        [self setEditState:ATFVEditStateEditing];
    }
    [self.inputTextFiled becomeFirstResponder];
}

#pragma mark - 进行布局
- (void)ATFVAddSubViews {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self addSubview:self.inputTextFiled];
    [self addSubview:self.bottomLineView];
    [self addSubview:self.inputPromptTitleLabel];
}

- (void)ATFVAutoLayouts {
    [self.inputTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        [self ATFVSetTextFiledAutoLayout:make];
    }];
    [self.inputPromptTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_style.editState == ATFVEditStateNormal) {
            [self ATFVSetTextFiledAutoLayout:make];
        }else {
            make.leading.equalTo(self);
            make.top.mas_offset(5);
        }
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(self->_style.bottomLineHeight);
    }];

}

- (void)ATFVSetTextFiledAutoLayout:(MASConstraintMaker *)make {
    make.leading.trailing.equalTo(self);
    make.bottom.mas_offset(-self->_style.bottomLineHeight);
    make.height.mas_equalTo(33);
}

- (void)ATFVStepStyle {
    if (_style.editState == ATFVEditStateEditing) {
        self.inputPromptTitleLabel.textColor = _style.inputPromptHighlightColor;
        self.inputPromptTitleLabel.font = _style.inputAddressFiledFont;
        self.bottomLineView.backgroundColor = _style.inputAddressFiledTextColor;
    }else {
        self.inputPromptTitleLabel.textColor = _style.inputPromptNormalColor;
        self.inputPromptTitleLabel.font = _style.inputPromptLabelFont;
        self.bottomLineView.backgroundColor = _style.bottomLineNormalColor;
    }

    if (_style.editState == ATFVEditStateNormal) {
        self.inputTextFiled.hidden = YES;
    }else {
        self.inputTextFiled.hidden = NO;
    }

    if (_style.editState == ATFVEditStateEdited) {
        self.inputTextFiled.text = _style.inputAddressText;
    }

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return _isAllowEdit;
}

#pragma mark - Setter
- (void)setInputText:(NSString *)inputText {
    self.inputTextFiled.text = inputText;
    _style.inputAddressText = inputText;
    [self setEditState:ATFVEditStateEdited];
}

#pragma mark - Getter
- (UILabel *)inputPromptTitleLabel {
	if (_inputPromptTitleLabel == nil) {
        _inputPromptTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _inputPromptTitleLabel.font = _style.inputPromptLabelFont;
        _inputPromptTitleLabel.text = _style.inputPromptText;
        _inputPromptTitleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movePromptToTop)];
        [_inputPromptTitleLabel addGestureRecognizer:tap];
	}
	return _inputPromptTitleLabel;
}

- (UITextField *)inputTextFiled {
	if (_inputTextFiled == nil) {
        _inputTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
        _inputTextFiled.font = _style.inputAddressFiledFont;
        _inputTextFiled.textColor = _style.inputAddressFiledTextColor;
        _inputTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextFiled.delegate = self;
        _inputTextFiled.returnKeyType = UIReturnKeyNext;
        UIButton *btn = [_inputTextFiled valueForKey:@"_clearButton"];
        [btn setImage:[NSBundle ATF_imageNamed:@"images/ATF_close"] forState:UIControlStateNormal];
	}
	return _inputTextFiled;
}

- (UIView *)bottomLineView {
	if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
	}
	return _bottomLineView;
}


- (NSString *)inputText {
   return self.inputTextFiled.text;
}

@end
