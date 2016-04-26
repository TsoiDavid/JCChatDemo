//
//  JCChatToolBar.m
//  JCChatDemo
//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import "JCChatToolBar.h"

@interface JCChatToolBar ()<UITextViewDelegate>
{
    CGFloat oldTextViewHeight;
}
@end

@implementation JCChatToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
  
    self.backgroundColor = [UIColor yellowColor];
    
    _textView = [[UITextView alloc]init];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:17];
    CGSize size = [_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, MAXFLOAT)];
//    NSLog(@"size === %@",NSStringFromCGSize(size));
    _textView.frame = CGRectMake(40, (self.frame.size.height - size.height)/2, self.frame.size.width - 80, size.height);
    
    oldTextViewHeight = self.frame.size.height - _textView.frame.size.height;
//    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
//    _textView.font = [UIFont systemFontOfSize:15];
    [self addSubview:_textView];
}
- (void)textViewDidChange:(UITextView *)textView {
    
    [self.textView flashScrollIndicators];   // 闪动滚动条
    //        CGFloat g = self.textView.font.lineHeight;
    static CGFloat maxHeight = 60;
    CGRect frame = self.textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    CGFloat upY ;
    if (oldTextViewHeight != size.height) {
        upY = size.height - oldTextViewHeight;
    }
    
    
    if (size.height >= maxHeight)
    {
        size.height = maxHeight;
        self.textView.scrollEnabled = YES;   // 允许滚动
        
    }
    else
    {
        self.textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    
    
    
//    NSLog(@"_textView ==== %@",NSStringFromCGRect(_textView.frame));
    
    [self.delegate textViewChangeWithSize:size Frame:frame upY:oldTextViewHeight];

}

@end
