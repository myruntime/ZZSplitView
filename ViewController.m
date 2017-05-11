//
//  ViewController.m
//  ZZSplitView
//
//  Created by 朱胡亮 on 2017/5/11.
//  Copyright © 2017年 SAIC. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define TOUCH_DISTANCE  200
#define RIGHTVIEW_WIDTH  800

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArrary;
@property (nonatomic, strong) UIView *rightView;
@property (assign, readwrite, nonatomic) BOOL visible;
@property (nonatomic,assign) BOOL isMoving;
@property (nonatomic , assign) CGPoint startPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.dataArrary = [NSMutableArray array];
    for (int i=0; i<30; i++) {
        [self.dataArrary addObject:[NSString stringWithFormat:@"---dsfdsgfjdsjfdskfdshfelfmdnhvuijerknvfhduvioeklrmfjhbvreiokdl;,otobrktbjrtkopblrjio%d---",i]];
    }
    self.tableView.frame = self.view.frame;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.rightView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        _rightView.frame = CGRectMake(KScreenWidth, 0, RIGHTVIEW_WIDTH, self.view.frame.size.height);
        _rightView.backgroundColor = [UIColor redColor];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        panGestureRecognizer.delegate = self;
        [_rightView addGestureRecognizer:panGestureRecognizer];
    }
    return _rightView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        /*
         UITableViewStylePlain
         UITableViewStyleGrouped
         */
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


#pragma mark UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrary.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArrary[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.visible) {
        [self showRightView];
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"55");
    return 55;
}
- (void)showRightView {
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        
//        CGSize size = CGSizeMake(KScreenWidth-RIGHTVIEW_WIDTH, KScreenHeight);
//        CGAffineTransform t = CGAffineTransformMakeScale(1.0,1.0);
//        CGRect frame = weakSelf.tableView.frame;
//        frame.size = CGSizeApplyAffineTransform(size, t);
//        weakSelf.tableView.frame = frame;
//        [weakSelf.rightView setTransform:(CGAffineTransformMakeTranslation(-RIGHTVIEW_WIDTH,0))];
//        weakSelf.visible = YES;
//        [weakSelf.tableView setNeedsLayout];
        
        CGRect frame = CGRectMake(0, 0, weakSelf.view.frame.size.width - RIGHTVIEW_WIDTH, self.view.frame.size.height);
        weakSelf.tableView.frame = frame;
        [weakSelf.tableView layoutIfNeeded];
        
        CGRect rightframe = CGRectMake(weakSelf.view.frame.size.width - RIGHTVIEW_WIDTH, 0, RIGHTVIEW_WIDTH, self.view.frame.size.height);
        weakSelf.rightView.frame = rightframe;
        weakSelf.visible = YES;
        
    }];
}

- (void)hideRightView {
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        
//        CGSize size = CGSizeMake(KScreenWidth, KScreenHeight);
//        CGAffineTransform t = CGAffineTransformMakeScale(1.0,1.0);
//        CGRect frame = weakSelf.tableView.frame;
//        frame.size = CGSizeApplyAffineTransform(size, t);
//        weakSelf.tableView.frame = frame;
//        [weakSelf.rightView setTransform:(CGAffineTransformMakeTranslation(RIGHTVIEW_WIDTH,0))];
//        weakSelf.visible = NO;
//        [weakSelf.tableView setNeedsLayout];
        weakSelf.tableView.frame = CGRectMake(0, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
        [weakSelf.tableView layoutIfNeeded];
        
        weakSelf.rightView.frame = CGRectMake(weakSelf.view.frame.size.width, 0, RIGHTVIEW_WIDTH, weakSelf.view.frame.size.height);
        weakSelf.visible = NO;
    }];
}


#pragma mark UIGestureRecognizer Delegate (Private)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !self.visible) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.x < KScreenWidth || point.x > KScreenWidth - RIGHTVIEW_WIDTH) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}


#pragma mark -
#pragma mark Pan gesture recognizer (Private)

- (void)panGestureRecognized:(UIPanGestureRecognizer *)pan {
    CGPoint touchPoint = [pan locationInView:self.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"UIGestureRecognizerStateBegan");
            _isMoving = YES;
            self.startPoint = touchPoint;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (_isMoving) [self doMoveViewWithX:touchPoint.x - self.startPoint.x];
            NSLog(@"UIGestureRecognizerStateChanged %f--%f ",touchPoint.x,self.startPoint.x);
        }
            break;
        case UIGestureRecognizerStateEnded: {
            NSLog(@"UIGestureRecognizerStateEnded");
            _isMoving = NO;
            [self gestureRecognizerStateEndedWithX:touchPoint.x];
        }
            break;
        case UIGestureRecognizerStateCancelled: {
            NSLog(@"UIGestureRecognizerStateCancelled");
            _isMoving = NO;
            [self gestureRecognizerStateEndedWithX:touchPoint.x];
        }
            break;
        default:
            break;
    }
    
}

- (void)doMoveViewWithX:(CGFloat)x {
    
    x = x > KScreenWidth ? KScreenWidth : x;
    x = x < 0 ? 0 : x;
    //左边可以渐变 考虑到cell高度约束的问题暂时注销
//    CGSize size = CGSizeMake(KScreenWidth-RIGHTVIEW_WIDTH+x, KScreenHeight);
//    CGRect frame = self.tableView.frame;
//    frame.size = size;
//    self.tableView.frame = frame;
//    [self.tableView layoutIfNeeded];
    
    CGRect rightframe = CGRectMake(KScreenWidth-RIGHTVIEW_WIDTH+x, 0, RIGHTVIEW_WIDTH, self.view.frame.size.height);
    self.rightView.frame = rightframe;

}

- (void)gestureRecognizerStateEndedWithX:(CGFloat)x {
    if (x - self.startPoint.x < TOUCH_DISTANCE) {
        CGRect frame = CGRectMake(0, 0, KScreenWidth - RIGHTVIEW_WIDTH, self.view.frame.size.height);
        self.tableView.frame = frame;
        [self.tableView layoutIfNeeded];
        
        CGRect rightframe = CGRectMake(KScreenWidth - RIGHTVIEW_WIDTH, 0, RIGHTVIEW_WIDTH, self.view.frame.size.height);
        self.rightView.frame = rightframe;
        self.visible = YES;
    }else {
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.tableView layoutIfNeeded];

        self.rightView.frame = CGRectMake(KScreenWidth, 0, RIGHTVIEW_WIDTH, self.view.frame.size.height);
        self.visible = NO;
    }
}

@end
