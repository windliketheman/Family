//
//  UIView+LoadingPrompt.h
//  ennew
//
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LoadingPrompt)

- (void)showLoadingViewWithText:(NSString *)text;

- (void)hideLoadingView;

- (void)showPromptWithMessage:(NSString *)message;

@end
