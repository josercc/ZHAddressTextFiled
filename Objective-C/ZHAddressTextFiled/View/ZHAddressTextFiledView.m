//
//  ZHAddressTextFiledView.m
//  ZHAddressTextFiled-Objective-C
//
//  Created by 张行 on 2016/12/13.
//  Copyright © 2016年 张行. All rights reserved.
//

#import "ZHAddressTextFiledView.h"
#import "ZHAddressTextFiledViewStyle.h"
#import <Masonry/Masonry.h>
#import "ZHAddressErrorTipView.h"

@interface ZHAddressTextFiledView ()<UITextFieldDelegate>

/**
 输入提示
 */
@property (nonatomic, strong) UILabel *inputPromptTitleLabel;
/**
 输入信息的输入框
 */
@property (nonatomic, strong) UITextField *inputTextFiled;
/**
 底部的分割线
 */
@property (nonatomic, strong) UIView *bottomLineView;


@end

@implementation ZHAddressTextFiledView {
    ZHAddressTextFiledViewStyle *_style;
}

#pragma mark - Init
- (ZHAddressTextFiledView *)initWithStyle:(ZHAddressTextFiledViewStyle *)style
                                    frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _style = style;
        self.backgroundColor = [UIColor whiteColor];
        [self ATFV_InitState];
    }
    return self;
}

- (void)ATFV_InitState {
    [self ATFVAddSubViews];
    [self ATFVAutoLayouts];
    [self ATFVStepStyle];
}

/**
 更新当前的状态

 @param state 当前的状态
 */
- (void)setEditState:(ATFVEditState)state {
    if (state == ATFVEditStateEdited) {
        if (!_style.inputAddressText) {
            state = ATFVEditStateNormal;
        }else if(_style.inputAddressText.length == 0 && _style.requiredInput == YES){
            state = ATFVEditStateEditedError;
        }
    }
    _style.editState = state;
    // 设置提示语的位置
    [UIView animateWithDuration:0.25 animations:^{
        [self.inputPromptTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            if (state != ATFVEditStateNormal) {
                make.top.mas_offset(5);
            }else {
                make.bottom.mas_offset(self->_style.bottomLineHeight);
                make.height.mas_equalTo(33);
            }
        }];
    }];
    // 设置提示语的颜色
    self.inputPromptTitleLabel.textColor = _style.editState == ATFVEditStateEditing ? _style.inputPromptHighlightColor : _style.inputPromptNormalColor;
    // 设置提示语的大小
    self.inputPromptTitleLabel.font = _style.editState == ATFVEditStateNormal ? _style.inputAddressFiledFont : _style.inputPromptLabelFont;
    // 设置分割线的颜色
    self.bottomLineView.backgroundColor = _style.editState != ATFVEditStateEditing ? _style.bottomLineNormalColor : _style.inputAddressFiledTextColor;
    // 设置输入法是否隐藏
    self.inputTextFiled.hidden = _style.editState == ATFVEditStateNormal;
    // 是否隐藏错误提示
    if (state == ATFVEditStateEditedError && _style.errorTipText.length > 0) {
        [[ZHAddressErrorTipView sharedInstance] showInAddressView:self errorTipString:_style.errorTipText];
    }
}

#pragma mark - 移动提示文本到顶部
- (void)movePromptToTop {
    if (_style.editState != ATFVEditStateNormal) {
        return;
    }
    [self setEditState:ATFVEditStateEditing];
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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIView *errorTipSuperView = [ZHAddressErrorTipView sharedInstance].superview;
    if (errorTipSuperView && [errorTipSuperView isEqual:self]) {
        [[ZHAddressErrorTipView sharedInstance] hide];
    }
    [self setEditState:ATFVEditStateEditing];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _style.inputAddressText = textField.text;
    [self setEditState:ATFVEditStateEdited];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _style.inputAddressText = textField.text;
    [self setEditState:ATFVEditStateEdited];
    return YES;
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
        [btn setImage:[UIImage imageNamed:@"ATF_close"] forState:UIControlStateNormal];
	}
	return _inputTextFiled;
}

- (UIView *)bottomLineView {
	if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
	}
	return _bottomLineView;
}


@end
