//
//  NSBundle+ZHAddressTextFiled.m
//  Pods
//
//  Created by 张行 on 2016/12/16.
//
//

#import "NSBundle+ZHAddressTextFiled.h"
#import "ZHAddressTextFiledView.h"

@implementation NSBundle (ZHAddressTextFiled)

+ (NSBundle *)ATF_Bundle {
    static NSBundle *bundle;
    if (!bundle) {
        bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[ZHAddressTextFiledView class]] URLForResource:@"ZHAddressTextFiled" withExtension:@"bundle"]];
    }
    return bundle;
}

+ (UIImage *)ATF_imageNamed:(NSString *)imageName {
    return [UIImage imageWithContentsOfFile:[[NSBundle ATF_Bundle] pathForResource:imageName ofType:@"png"]];
}

@end
