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
        bundle = [NSBundle bundleForClass:[ZHAddressTextFiledView class]];
    }
    return bundle;
}

+ (UIImage *)ATF_imageNamed:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle ATF_Bundle] compatibleWithTraitCollection:nil];
    return image;
}

@end
