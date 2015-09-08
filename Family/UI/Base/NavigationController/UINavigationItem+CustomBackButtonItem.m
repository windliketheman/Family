//
//  UINavigationItem+CustomBackButtonItem.m
//  FileBox
//
//  Created by jia on 15/9/5.
//  Copyright (c) 2015年 OrangeTeam. All rights reserved.
//

#import "UINavigationItem+CustomBackButtonItem.h"

@implementation UINavigationItem (CustomBackButtonItem)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethodImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method destMethodImp = class_getInstanceMethod(self, @selector(myCustomBackButton_backBarbuttonItem));
        method_exchangeImplementations(originalMethodImp, destMethodImp);
    });
}

static char customBackButtonKey;
- (UIBarButtonItem *)myCustomBackButton_backBarbuttonItem{
    UIBarButtonItem *item = [self myCustomBackButton_backBarbuttonItem];
    if (item)
    {
        return item;
    }
    
    item = objc_getAssociatedObject(self, &customBackButtonKey);
    if (!item)
    {
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:NULL];
        objc_setAssociatedObject(self, &customBackButtonKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

- (void)dealloc
{
    objc_removeAssociatedObjects(self);
}

@end
