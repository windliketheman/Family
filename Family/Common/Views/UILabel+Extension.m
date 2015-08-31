//
//  UILabel+Extension.m
//  FileBox
//
//  Created by junbo jia on 14/12/12.
//  Copyright (c) 2014年 OrangeTeam. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (TextSize)

- (CGSize)contentTextSize
{
    if (!self.text)
    {
        return self.bounds.size;
    }
    
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize textSize;
    CGSize maximumLabelSize = CGSizeMake(CGRectGetWidth(self.bounds), MAXFLOAT);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = self.lineBreakMode;
        paragraphStyle.alignment = self.textAlignment;
        
        // NSStringDrawingTruncatesLastVisibleLine: 如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略。
        textSize = [self.text boundingRectWithSize:maximumLabelSize
                                           options:(NSStringDrawingTruncatesLastVisibleLine
                                                    | NSStringDrawingUsesLineFragmentOrigin
                                                    | NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName : self.font,
                                                     NSParagraphStyleAttributeName : paragraphStyle}
                                           context:nil].size;
        textSize.width = ceil(textSize.width);
        textSize.height = ceil(textSize.height);
    }
    else
    {
        //[self setNumberOfLines:0];
        //[self setLineBreakMode:NSLineBreakByWordWrapping];
        
        //CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,kMaxLabelHeight);
        textSize = [self.text sizeWithFont:self.font constrainedToSize:maximumLabelSize lineBreakMode:self.lineBreakMode];
    }
    
    return textSize;
    
#if 0
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0f)
    {
        CGSize size = [self.text boundingRectWithSize:self.bounds.size withTextFont:self.font withLineSpacing:5];
        return size;
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text];
        // self.attributedText = attrStr;
        NSRange range = NSMakeRange(0, attrStr.length);
        NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];   // 获取该段attributedString的属性字典
        
        // 计算文本的大小
        CGSize textSize = [self.text boundingRectWithSize:self.bounds.size // 用于计算文本绘制时占据的矩形块
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                               attributes:dic        // 文字的属性
                                                  context:nil].size;
        
        return textSize;
    }
    else
    {
        CGSize size = [self.text sizeWithFont:self.font constrainedToSize:self.bounds.size lineBreakMode:self.lineBreakMode];
        return size;
    }
#endif
}

@end
