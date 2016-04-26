//
//  JCChatToolBar.h
//  JCChatDemo
//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCChatToolBarDelegate <NSObject>

@required
//告诉控制器要修改toolbar大小位置回调
- (void)textViewChangeWithSize:(CGSize)size Frame:(CGRect)frame upY:(CGFloat)y;

@end

@interface JCChatToolBar : UIView

@property (strong, nonatomic) UITextView *textView;

@property (weak, nonatomic) id<JCChatToolBarDelegate> delegate;

@end
