//
//  ViewController.m
//  CRPullZoom
//
//  Created by Jonren on 16/8/28.
//  Copyright © 2016年 常宣任. All rights reserved.
//

#import "ViewController.h"

static NSString *MyCellIdentifier = @"MyCell";
static CGFloat const ImageHeight = 250.0f;  // 图片高度可自己设定

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width


@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:MyCellIdentifier];
    // 设置偏移量，这样能够让偏移出的部分显示图片。
    [_table setContentInset:UIEdgeInsetsMake(ImageHeight, 0, 0, 0)];
    _table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_table];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -ImageHeight, ScreenWidth, ImageHeight)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.image = [UIImage imageNamed:@"girl.jpg"];
    
    // 本例采用insertSubview方法实现，也可以将图片添加到tableHeaderView，或者将图片添加到self.view和table之间两种方式实现。
    [_table insertSubview:_imageView atIndex:0];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = @"girl";
    return cell;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat newImageHeight = -scrollView.contentOffset.y;
    NSLog(@"偏移量：%f", newImageHeight);

    UIImageView *imageView = (UIImageView *)[_table subviews][0];
    
    CGFloat x = newImageHeight/ImageHeight; // 放大倍数
    CGFloat newWidth = x*(ScreenWidth);     // 图片新宽度
    CGFloat originX = -(newWidth-ScreenWidth)/2;  // 图片新横坐标
    
    // 设置新frame时需要注意size不要小于初始位置的size
    imageView.frame = CGRectMake(originX<0?originX:0, -newImageHeight, newWidth>ScreenWidth?newWidth:ScreenWidth, newImageHeight);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
