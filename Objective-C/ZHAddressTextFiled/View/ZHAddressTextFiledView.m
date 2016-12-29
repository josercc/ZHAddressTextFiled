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


@interface ZHAddressTextFiledView ()<UITextFieldDelegate, UIGestureRecognizerDelegate>

/*!
 显示提示文字
 */
@property(nonatomic, strong) UILabel *inputPromptTitleLabel;
/*!
 输入信息的输入框
 */
@property(nonatomic, strong) UITextField *inputTextFiled;
/*!
 底部的分割线
 */
@property(nonatomic, strong) UIView *bottomLineView;
/**
 覆盖在TextFiled上面的点击区域
 */
@property(nonatomic, strong) UIView *tapView;
@property(nonatomic, strong) UILabel *inputTextFiledPrefixLabel;

@end

@implementation ZHAddressTextFiledView {
    ZHAddressTextFiledViewStyle *_style; // 当前输入框的样式
    BOOL _isAllowEdit; // 是否允许编辑
    MASConstraint *_tapViewRightContraint;
}

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // 移除界面所有的通知
}

#pragma mark - Init
- (ZHAddressTextFiledView *)initWithStyle:(ZHAddressTextFiledViewStyle *)style frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _style = style;
        _isAllowEdit = YES; // 默认允许编辑
        self.backgroundColor = [UIColor whiteColor];
        [self atfvInitState]; // 初始化状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    }
    return self;
}

- (void)atfvInitState {
    [self atfvAddSubViews];
    [self atfvAutoLayouts];
    [self atfvStepStyle];
}

/*!
 查找的输入框是否是当前界面的输入框

 @param textFiled 查找的输入框
 @return 如果是YES代表是 如果是NO代表不是
 */
- (BOOL)isEqualTextFiled:(UITextField *)textFiled {
    return [self.inputTextFiled isEqual:textFiled];
}

#pragma mark - 开始编辑
/*!
 输入框开始编辑开始

 @param notication 通知
 */
- (void)beginEditingNotification:(NSNotification *)notication {
    ZHAddressTextFiledView *errorTipSuperView = [ZHAddressErrorTipView sharedInstance].showInAddressTextFiledView;
    if (errorTipSuperView && [errorTipSuperView isEqualTextFiled:notication.object]) {
        // 如果错误试图父试图存在 并且正在编辑的是正在展示错误的试图 移除错误提示
        [[ZHAddressErrorTipView sharedInstance] hide];
    }else if(!_isAllowEdit){
        // 如果是不允许用户编辑 如果当前没内容就恢复默认 如果有内容就设置结束状态
        [self setEditState:_style.inputAddressText.length > 0 ? ATFVEditStateEdited : ATFVEditStateNormal];
    }
}

#pragma mark - 结束编辑
/*!
 输入框结束编辑

 @param notication 通知
 */
- (void)endEditingNotification:(NSNotification *)notication {
    if ([self.inputTextFiled isEqual:notication.object]) {
        // 如果当前界面的输入框等于结束编辑的输入框 保存编辑框的内容 让之前的界面状态结束
        _style.inputAddressText = self.inputTextFiled.text;
        [self setEditState:ATFVEditStateEdited];
        _tapViewRightContraint.mas_offset(0);
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
        if (!_style.inputAddressText || (!_style.requiredInput && _style.inputAddressText.length == 0)) {
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
            make.trailing.equalTo(self);
            if (isMovePromptTop) {
                make.top.mas_offset(5);
                make.leading.equalTo(self.inputTextFiledPrefixLabel);
            }else {
                make.leading.equalTo(self.inputTextFiledPrefixLabel.mas_trailing);
                make.bottom.mas_offset(self->_style.bottomLineHeight);
                make.height.mas_equalTo(33);
            }
        }];
    }];
    // 设置提示语的颜色 如果正在编辑高亮  结束就恢复默认的颜色
    self.inputPromptTitleLabel.textColor = _style.editState == ATFVEditStateEditing ? _style.inputPromptHighlightColor : _style.inputPromptNormalColor;
    // 设置提示语的大小 只有恢复原来位置字体和输入框字体大小一致 不然恢复原来的字体
    self.inputPromptTitleLabel.font = isMovePromptTop ? _style.inputPromptLabelFont : _style.inputAddressFiledFont;
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
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(shouldAllowTextFiledEdit:)]) {
        _isAllowEdit = [self.dataSource shouldAllowTextFiledEdit:self];
    }
    if (_isAllowEdit) {
        [self setEditState:ATFVEditStateEditing];
        [self.inputTextFiled becomeFirstResponder];
    }

}

#pragma mark - 进行布局
- (void)atfvAddSubViews {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self addSubview:self.inputTextFiledPrefixLabel];
    [self addSubview:self.inputTextFiled];
    [self addSubview:self.bottomLineView];
    [self addSubview:self.tapView];
    [self addSubview:self.inputPromptTitleLabel];
}

- (void)atfvAutoLayouts {
    [self.inputTextFiledPrefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inputTextFiled);
        make.leading.equalTo(self);
    }];
    [self.inputTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        [self ATFVSetTextFiledAutoLayout:make];
    }];
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.inputTextFiledPrefixLabel.mas_trailing);
        self->_tapViewRightContraint = make.trailing.equalTo(self);
        make.bottom.mas_offset(-self->_style.bottomLineHeight);
        make.height.mas_equalTo(33);
    }];
    [self.inputPromptTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        BOOL isNormalLabelInTextFiled = _style.editState == ATFVEditStateNormal;
        if (isNormalLabelInTextFiled) {
            [self ATFVSetTextFiledAutoLayout:make];
        }else {
            make.leading.equalTo(self.inputTextFiledPrefixLabel);
            make.top.mas_offset(5);
        }
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(self->_style.bottomLineHeight);
    }];

}

- (void)ATFVSetTextFiledAutoLayout:(MASConstraintMaker *)make {
    make.leading.equalTo(self.inputTextFiledPrefixLabel.mas_trailing);
    make.trailing.equalTo(self);
    make.bottom.mas_offset(-self->_style.bottomLineHeight);
    make.height.mas_equalTo(33);
}

- (void)atfvStepStyle {
    if (_style.editState == ATFVEditStateEditing) {
        // 当处于正在编辑状态 提示语高亮 字体变大 分割线高亮
        self.inputPromptTitleLabel.textColor = _style.inputPromptHighlightColor;
        self.bottomLineView.backgroundColor = _style.inputAddressFiledTextColor;
    }else {
        self.inputPromptTitleLabel.textColor = _style.inputPromptNormalColor;
        self.bottomLineView.backgroundColor = _style.bottomLineNormalColor;
    }


    if (_style.editState == ATFVEditStateNormal) {
        self.inputTextFiled.hidden = YES;
        self.inputPromptTitleLabel.font = _style.inputAddressFiledFont;
    }else {
        self.inputTextFiled.hidden = NO;
        self.inputPromptTitleLabel.font = _style.inputPromptLabelFont;
    }

    if (_style.editState == ATFVEditStateEdited) {
        self.inputTextFiled.text = _style.inputAddressText;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_isAllowEdit) {
        _tapViewRightContraint.mas_offset(-30);
    }
    return _isAllowEdit;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tapView.hidden = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.tapView.hidden = NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark - Setter
- (void)setInputText:(NSString *)inputText {
    self.inputTextFiled.text = inputText;
    _style.inputAddressText = inputText;
    [self setEditState:ATFVEditStateEdited];
}

- (void)setInputPrefixText:(NSString *)inputPrefixText {
    _inputPrefixText = inputPrefixText;
    self.inputTextFiledPrefixLabel.text = inputPrefixText;
}

- (void)setDataSource:(id<ZHAddressTextFiledViewDataSource>)dataSource {
    _dataSource = dataSource;
//    if (dataSource && [dataSource respondsToSelector:@selector(shouldAllowTextFiledEdit:)]) {
//        _isAllowEdit = [dataSource shouldAllowTextFiledEdit:self];
//        self.inputTextFiled.userInteractionEnabled = _isAllowEdit;
//    }
}

#pragma mark - Getter
- (UILabel *)inputPromptTitleLabel {
	if (_inputPromptTitleLabel == nil) {
        _inputPromptTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _inputPromptTitleLabel.font = _style.inputPromptLabelFont;
        _inputPromptTitleLabel.text = _style.inputPromptText;
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

- (NSString *)inputText {
   return _style.inputAddressText;
}

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc] initWithFrame:CGRectZero];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movePromptToTop)];
        tap.delegate = self;
        [_tapView addGestureRecognizer:tap];
    }
    return _tapView;
}

- (UILabel *)inputTextFiledPrefixLabel {
    if (!_inputTextFiledPrefixLabel) {
        _inputTextFiledPrefixLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _inputTextFiledPrefixLabel.textColor = _style.inputAddressFiledTextColor;
        _inputTextFiledPrefixLabel.font = _style.inputAddressFiledFont;
        [_inputTextFiledPrefixLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _inputTextFiledPrefixLabel;
}

@end
