# ZHAddressTextFiled

> ## 1.1.2 新增功能
>
> ```objc
> /**
>  错误提示展示的父试图 解决提示语被遮挡的BUG 如果为nil则自动判断
>  */
> @property(nonatomic, strong) UIView *errorSuperView;
> ```
> 我发现把控件放在Cell上面 因为之前是添加到TextFiled上面的 会被下面的Cell遮挡提示框
>
> 新增上面属性 让用户赋值 直接把提示语添加到父试图上面
>
> 比如我赋值给tableview
>
> ```objc
> [ZHAddressErrorTipView sharedInstance].errorSuperView = self.tableView;
> ```
> 完美解决出现的bug

这个输入框是输入把默认提示语上移，我记得有第三方库，但是我就想造轮子，所以就除了这个。

现在支持以下:

- [x] 输入框四种状态
- [x] 输入自动显示正确的类型
- [x] 自动显示错误的提示
- [x] 可扩展
- [x] 支持Cocoapods

输入框四种状态:

1. 默认状态:ATFVEditStateNormal

   ![](http://ww1.sinaimg.cn/large/006tNc79gw1fascx8m90qj30dg01ydfq.jpg)

   显示输入框提示语 分割线暗色

2. 编辑状态:ATFVEditStateEditing

   ![](http://ww4.sinaimg.cn/large/006tNc79gw1fascyu0dcrj30de02dq2v.jpg)

   默认的提示语上移上面 分割线高亮

3. 编辑完成:ATFVEditStateEdited

   ![](http://ww3.sinaimg.cn/large/006tNc79gw1fasd1363n6j30di02ba9z.jpg)

4. 显示错误的提示语:ATFVEditStateEditedError

   ![](http://ww3.sinaimg.cn/large/006tNc79gw1fasghrdibfj30d101z3yh.jpg)

## 安装

1. 直接下载github的库 拖拽ZHAddressTextFiled文件包到工程

2. 使用cocoapods安装

   ```ruby
   pod ZHAddressTextFiled
   ```

## 怎么使用

新建一个输入框样式表

```objective-c
ZHAddressTextFiledViewStyle *style = [[ZHAddressTextFiledViewStyle alloc] init]
```

你可以在样式表配置自己喜欢的样式

初始化输入框

```objective-c
ZHAddressTextFiledView *addressView = [[ZHAddressTextFiledView alloc] initWithStyle:style frame:CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width - 40, 50)];
```

自定义验证错误信息

```objective-c
addressView.validateInputCorrectComplete = ^NSString *(NSString *inputText) {
        if (inputText.length <= 2) {
            return @"输入的长度必须大于2";
        }
        return nil;
    };
```
