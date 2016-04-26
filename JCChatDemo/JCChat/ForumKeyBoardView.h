//
//  ForumKeyBoardView.h
//  PlusStar_1.0
//
//  Created by TsoiKaShing on 15/10/12.
//  Copyright © 2015年 HuangZhenXiang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LPlaceholderTextView.h"

@protocol ForumKeyBoardViewDelegate <NSObject>

- (void)didSelectSendWithContent:(NSString *)content;
- (void)didSelectPickImage;
- (void)changeTextViewFrameWhentextViewDidChangeWithSize:(CGSize)newSize;
@end

@interface ForumKeyBoardView : UIView<UITextViewDelegate>
+(ForumKeyBoardView *)instanceView;

@property (weak, nonatomic) IBOutlet UITextView *contenTextView;

@property (weak,nonatomic) id<ForumKeyBoardViewDelegate> delegate;
@end
