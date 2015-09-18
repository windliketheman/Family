//
//  LoadingView.h
//  ennew
//
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

- (instancetype)initWithSize:(CGSize)size;

- (void)showLoadingText:(NSString *)text inView:(UIView *)superView;

- (void)hide;

@end
