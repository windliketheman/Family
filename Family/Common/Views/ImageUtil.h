//
//  ImageUtil.h
//  ennew
//  图片公共类
//  Created by mijibao on 15/7/3.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UIImageRoundedCornerTopLeft = 1,
    UIImageRoundedCornerTopRight = 1 << 1,
    UIImageRoundedCornerBottomRight = 1 << 2,
    UIImageRoundedCornerBottomLeft = 1 << 3
} UIImageRoundedCorner;
@interface ImageUtil : NSObject

-(void)addRoundedRectToPath:(CGContextRef)context withrect:(CGRect)rect radius:(float)radius mask:(UIImageRoundedCorner)cornerMask;
- (UIImage *)roundedRectImage:(UIImage *)srcimage withradius:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask;

+(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset;
@end
