//
//  ForumKeyBoardView.m
//  PlusStar_1.0
//
//  Created by TsoiKaShing on 15/10/12.
//  Copyright © 2015年 HuangZhenXiang. All rights reserved.
//

#import "ForumKeyBoardView.h"

@interface ForumKeyBoardView()
{
    CGFloat textViewOldHeight;
    CGFloat currentLine;
}
@end

@implementation ForumKeyBoardView

+(ForumKeyBoardView *)instanceView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ForumKeyBoardView" owner:nil options:nil];
    
    return [nibView objectAtIndex:0];
    
}
- (void) awakeFromNib
{
    [super awakeFromNib];
    textViewOldHeight = self.contenTextView.frame.size.height;
    currentLine = 1;
    NSLog(@"textViewOldHeight = %f",textViewOldHeight);
    self.contenTextView.delegate = self;
    self.contenTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.contenTextView.layer.borderWidth = 0.5;
    self.contenTextView.layer.cornerRadius = 6;
    self.contenTextView.layer.masksToBounds = YES;
  
//    self.contenTextView.placeholderText = @"输入你的图片配文..";
//    self.contenTextView.placeholderColor = [UIColor lightGrayColor];

    
}
- (IBAction)sendAction {
    
    [self.delegate didSelectSendWithContent:self.contenTextView.text];
   
}
- (IBAction)pickImage {
    
    [self.delegate didSelectPickImage];
}
-(void)textViewDidChange:(UITextView *)textView
{
    //计算文字行数
    /*
     CGFloat labelHeight = [self.testLabel sizeThatFits:CGSizeMake(self.testLabel.frame.size.width, MAXFLOAT)].height;
     NSNumber *count = @((labelHeight) / self.testLabel.font.lineHeight);
     NSLog(@"共 %td 行", [count integerValue]);
     */
    CGFloat fixedWidth = textView.frame.size.width;
    //MAXFLOAT 最大浮点数
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    //fmaxf 求最大值函数
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    //文字行数
    NSNumber *count = @((newSize.height) / self.contenTextView.font.lineHeight);
    
    if (currentLine == count.integerValue) {return;};
    
    if (count.integerValue >= 1  && count.integerValue <= 3) {
        currentLine = count.integerValue;
        
        if (count.integerValue == 1) {
            newSize.height = textViewOldHeight + 10;
        }
        //文字行数1-3行内高度变化
        CGRect rect = self.contenTextView.frame;
        
        NSLog(@"未变之前的size ==== %@",NSStringFromCGRect(rect));
        rect.size.height = newSize.height;
        self.contenTextView.frame = rect;
        self.contenTextView.contentSize = newSize;
        NSLog(@"改变之后的size ==== %@",NSStringFromCGRect(rect));
        //回调通知keyboardView的contentextView高度改变。
        [self.delegate changeTextViewFrameWhentextViewDidChangeWithSize:newSize];
    }
   
}



@end
