//
//  ViewController.m
//  LYMPhotoBrowserDemo
//
//  Created by leiyiming on 14/02/2017.
//  Copyright © 2017 leiyiming. All rights reserved.
//

#import "ViewController.h"
#import "LYMPhotoBrowser.h"

@interface ViewController ()
<LYMPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray * imageURLArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //数据
    self.imageURLArray = @[@"http://imgsrc.baidu.com/baike/pic/item/728da9773912b31b4d4df1ed8518367adbb4e1d5.jpg",
                           @"http://imgsrc.baidu.com/baike/pic/item/a686c9177f3e670925bea1353bc79f3df9dc55ba.jpg",
                           @"http://f.hiphotos.baidu.com/image/pic/item/48540923dd54564e27fe3603b4de9c82d1584f75.jpg",
                           @"http://h.hiphotos.baidu.com/image/pic/item/a9d3fd1f4134970af7d8c21592cad1c8a7865d65.jpg",
                           @"http://g.hiphotos.baidu.com/image/pic/item/b812c8fcc3cec3fd8afedc4ed188d43f869427cc.jpg",
                           @"http://e.hiphotos.baidu.com/image/pic/item/738b4710b912c8fcb7338df6fb039245d78821cc.jpg",
                           @"http://e.hiphotos.baidu.com/image/pic/item/b17eca8065380cd785f7d9d6a644ad345982811b.jpg",
                           @"http://d.hiphotos.baidu.com/image/pic/item/9213b07eca8065381f03df2890dda144ad34821b.jpg",
                           @"http://f.hiphotos.baidu.com/image/pic/item/342ac65c10385343f626fc1a9413b07eca80881b.jpg",
                           @"http://b.hiphotos.baidu.com/image/pic/item/d31b0ef41bd5ad6e5c5c1fd186cb39dbb6fd3c67.jpg",
                           @"http://a.hiphotos.baidu.com/image/pic/item/38dbb6fd5266d01681bce513902bd40735fa3567.jpg"
                           ];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[LYMPhotoBrowser alloc] initWithTotalImageCount:self.imageURLArray.count current:0 delegate:self] show];
    });
}


//MARK: - LYMPhotoBrowser Delegate
- (UIView *)photoBrowser:(LYMPhotoBrowser *)browser animationViewForIndex:(NSInteger)index {
    //返回图片浏览控件全屏动画的起始视图
    return nil;
}

- (UIImage *)photoBrowser:(LYMPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    //返回在图片浏览控件初始化时给的默认占位图，一般为清晰度不高的小图或默认图
    return nil;
}

- (NSURL *)photoBrowser:(LYMPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    //返回高清大图的url
    return [[NSURL alloc] initWithString:self.imageURLArray[index]];
}

- (void)photoBrowser:(LYMPhotoBrowser *)browser imageDownloadComplete:(UIImage *)image withURL:(NSURL *)url atIndex:(NSInteger)index {
    //图片下载成功之后调用此方法，可以在此转存下载好的图片
}


@end
