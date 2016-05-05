//
//  JCChatToolBar.m
//  JCChatDemo
//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import "JCChatToolBar.h"
//控件边距
static const CGFloat itemMargin = 10;
//按钮高度
static const CGFloat buttonHeight = 35;
//按钮宽度
static const CGFloat buttonWidth = 45;

@interface JCChatToolBar ()<UITextViewDelegate>
{
    //textview 距离chatbar高度上下一共的距离
    CGFloat oldTextViewHeight;
    //如果在init方法里面设置textview的frame 则不需要这个属性，这里是把frame放在layoutsubview里面刷新，会导致frame超出父视图，需要这个属性限制。
    BOOL shouldTextViewRefreshFrame;

}

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIButton *voiceButton;

@end

@implementation JCChatToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    self.leftButtonImageName = @"chat_voice_record";
    self.rightButtonImageName = @"Chat_take_picture";
//    self.sendButtonTitle = @"send";
    shouldTextViewRefreshFrame = YES;
  
    self.backgroundColor = [UIColor yellowColor];
    
    
    //输入框
    _textView = [[UITextView alloc]init];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.returnKeyType = UIReturnKeySend;
    
    //获取textView需要创建的高度
    CGSize size = [_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, MAXFLOAT)];
    //textview 距离chatbar高度上下总距离
    oldTextViewHeight = self.frame.size.height - size.height;
    
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_textView];
    
    
    
//    //右照片按钮
//    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_rightButton setImage:[UIImage imageNamed:@"Chat_take_picture"] forState:UIControlStateNormal];
//    [self addSubview:_rightButton];
  
    
}
- (UIButton *)voiceButton {
    _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_voiceButton setBackgroundColor:[UIColor grayColor]];
    return _voiceButton;
}
//清空textView内容
- (void)clearTextViewtoNormal {
    _textView.text = @"";
    [_textView resignFirstResponder];
}
- (void)buttonAction:(UIButton *)button {
    switch (button.tag) {
        case 10:
        {
            _leftButton.selected = _leftButton.selected == YES ? NO : YES;
            if (_leftButton.selected) {
                
                [self clearTextViewtoNormal];
                if(_voiceButton) return;
                [self addSubview:self.voiceButton];
            }else {
                if(!_voiceButton) return;
                [_voiceButton removeFromSuperview];
                _voiceButton = nil;
                [_textView becomeFirstResponder];
            }
            break;
        }
        case 11:
        {
            NSLog(@"11");
            [_textView resignFirstResponder];
            [self.delegate clickPhotoButton];
            break;
        }
        default:
            break;
    }
}
- (void)setLeftButtonImageName:(NSString *)leftButtonImageName {
    
    if (leftButtonImageName == nil) return;
    
    _leftButtonImageName = leftButtonImageName;
    
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_leftButton setImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateSelected];
        _leftButton.tag = 10;
        [_leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
    }
   
    [_leftButton setImage:[UIImage imageNamed:_leftButtonImageName] forState:UIControlStateNormal];
  
    
}
- (void)setRightButtonImageName:(NSString *)rightButtonImageName {
    
    if (rightButtonImageName == nil) return;
    
    _rightButtonImageName = rightButtonImageName;
    
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.tag = 11;
        [_rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
    }
    
    [_rightButton setImage:[UIImage imageNamed:_rightButtonImageName] forState:UIControlStateNormal];

}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    //左照片按钮
    if (_leftButton) {
        CGFloat leftButtonX = itemMargin;
        CGFloat leftButtonY = (self.frame.size.height - buttonHeight)/2;
        _leftButton.frame = CGRectMake(leftButtonX, leftButtonY, buttonHeight, buttonHeight);
        
    }
    
    CGFloat textViewX = _leftButton.frame.origin.x + _leftButton.frame.size.width + itemMargin;
//    //获取textView需要创建的高度
    if(shouldTextViewRefreshFrame){
        CGSize size = [_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, MAXFLOAT)];
        _textView.frame = CGRectMake(textViewX, (self.frame.size.height - size.height)/2, self.frame.size.width - 2 * (itemMargin * 2 + buttonHeight), size.height);
    }
    
    
    if(_rightButton) {
       //右照片按钮
       CGFloat rightButtonX = self.frame.size.width - (itemMargin + buttonHeight);
       CGFloat rightButtonY = (self.frame.size.height - buttonHeight)/2;
       _rightButton.frame = CGRectMake(rightButtonX, rightButtonY, buttonHeight, buttonHeight);
    }

    if (_voiceButton) {
        _voiceButton.frame = _textView.frame;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [ @"\n" isEqualToString: text]){
        NSLog(@"send");
        //你的响应方法
        
        return NO;
        
    }
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    // 闪动滚动条
    [self.textView flashScrollIndicators];
    
    CGFloat lineHeight = self.textView.font.lineHeight;
    //限制3行以内，才会发生变化
    CGFloat maxHeight = lineHeight * 3;
    
    CGRect frame = self.textView.frame;
    //获取textview当前内容需要的size
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    CGFloat moveUpY ;
    if (oldTextViewHeight != size.height) {
        //高度跟之前不一样就记录下来变化的高度，传给chatbar修正y的坐标
        moveUpY = size.height - oldTextViewHeight;
    }
    
    
    if (size.height >= maxHeight) {
        size.height = maxHeight;
        // 允许滚动
        self.textView.scrollEnabled = YES;
        shouldTextViewRefreshFrame = NO;
    }else {
        // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
        self.textView.scrollEnabled = NO;
        shouldTextViewRefreshFrame = YES;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
 
        self.textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    }];
    
    [self.delegate textViewChangeWithSize:size Frame:frame MoveUpY:oldTextViewHeight];
    
    

}

@end
