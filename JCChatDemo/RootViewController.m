//
//  RootViewController.m
//  JCChatDemo
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import "RootViewController.h"
#import "ForumKeyBoardView.h"

static const CGFloat keyboardHeight = 49;

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource,ForumKeyBoardViewDelegate>
{
    CGFloat textViewOldHeight;
    NSInteger navHeight;
    CGFloat keyboardhight;
    BOOL _wasKeyboardManagerEnabled;
    BOOL isKeyboardShow;
}
@property (strong, nonatomic) ForumKeyBoardView *keyboardView;
@property (strong, nonatomic) UITableView *chatTableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 15; i ++) {
        [_dataArray addObject:[NSString stringWithFormat:@"这是第%d行",i]];
    }
    
    [self setUI];
    //注册键盘通知监听
    [self registerNotifications];
    // Do any additional setup after loading the view from its nib.
}
- (void)dealloc
{
    //清除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setUI {
//   navHeight = self.navigationController != nil? 44 :0;

    self.view.backgroundColor = [UIColor whiteColor];
    
    _chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight) style:UITableViewStylePlain];
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    [self.view addSubview:_chatTableView];
    
    _keyboardView = [ForumKeyBoardView instanceView];
    _keyboardView.delegate = self;
    _keyboardView.backgroundColor = [UIColor yellowColor];
    _keyboardView.frame = CGRectMake(0,self.view.frame.size.height - keyboardHeight, self.view.frame.size.width, keyboardHeight);
    [self.view addSubview:_keyboardView];
}
#pragma mark *********键盘操作***********

//当textView内容发送变化，调整高度。
- (void)changeTextViewFrameWhentextViewDidChangeWithSize:(CGSize)newSize {
    
   
        CGRect rect = _keyboardView.frame;
        rect.origin.y = self.view.frame.size.height - keyboardhight - newSize.height;
        rect.size.height = newSize.height;
        _keyboardView.frame = rect;
    
    [self viewWillLayoutSubviews];
   
//    CGRect rect = _keyboardView.frame;
//    rect.origin.y = self.view.frame.size.height - keyboardhight - rect.size.height;
//    _keyboardView.frame = rect;
//    [_keyboardView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(@(newSize.height + 10));
//    }];
}
- (void)registerNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    isKeyboardShow = YES;
    
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    keyboardhight = kbSize.height;
    
 
    //    //输入框位置动画加载
    [self begainMoveUpAnimation:keyboardhight];
}
//键盘出现动画
-(void)begainMoveUpAnimation:(CGFloat)keyboardHight {
    
    [UIView animateKeyframesWithDuration:0 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
//        _chatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight - keyboardHight);
        _chatTableView.transform = CGAffineTransformMakeTranslation(0, -keyboardHight);
        _keyboardView.transform = CGAffineTransformMakeTranslation(0, -keyboardHight);
        [self tableViewScrollToBottom];
    } completion:^(BOOL finished) {
        
    }];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    isKeyboardShow = NO;
    
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    keyboardhight = kbSize.height;
  
    //输入框位置动画加载
    [self begainMoveDownAnimation:keyboardhight];
}
//键盘下落动画
- (void)begainMoveDownAnimation:(CGFloat)keyboardHight
{
    
    [UIView animateKeyframesWithDuration:0 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
//        _chatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight);
        _chatTableView.transform = CGAffineTransformIdentity;
        _keyboardView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_keyboardView.contenTextView resignFirstResponder];
}
#pragma mark - tableViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}
//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.dataArray.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end
