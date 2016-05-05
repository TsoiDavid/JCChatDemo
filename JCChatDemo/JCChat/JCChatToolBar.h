//
//  JCChatToolBar.h
//  JCChatDemo
//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, ButtonType) {
//    //编辑模式
//    EditStyle = 0,
//    //语音模式
//    VoiceStyle = 1,
//};

@protocol JCChatToolBarDelegate <NSObject>

@required
//告诉控制器要修改toolbar大小位置回调
- (void)textViewChangeWithSize:(CGSize)size Frame:(CGRect)frame MoveUpY:(CGFloat)y;
- (void)clickPhotoButton;
@end

@interface JCChatToolBar : UIView

@property (strong, nonatomic) UITextView *textView;
//左按钮图片属性，默认nil
@property (strong, nonatomic) NSString *leftButtonImageName;
//右按钮图片属性，默认nil
@property (strong, nonatomic) NSString *rightButtonImageName;



@property (weak, nonatomic) id<JCChatToolBarDelegate> delegate;


@end
