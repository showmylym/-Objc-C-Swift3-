//
//  LYMPhotoBrowser.m
//  LYMPhotoBrowser
//
//  Created by Jerry on 16-11-6.
//  Copyright (c) 2016年 Leiyiming. All rights reserved.
//

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#import "LYMPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "LYMPhotoBrowserOnePhotoScrollView.h"
#import "LYMPhotoBrowserConfig.h"
#import "UIInsetableLabel.h"
#import "UILabel+Extension.h"
#import "UIView+Coordinate.h"
#import "SVProgressHUD.h"

//  =============================================

@interface LYMPhotoBrowser ()
<LYMPhotoBrowserOnePhotoScrollViewDelegate>

//数据
@property (nonatomic) BOOL hasShowedFirstView;
@property (nonatomic, readwrite) NSInteger currentImageIndex;
@property (nonatomic, readwrite) NSInteger imageCount;
@property (nonatomic, strong) NSArray * defaultImageURLArr;

//控件
@property (nonatomic, strong) NSMutableArray<LYMPhotoBrowserOnePhotoScrollView *> * imageViewMuArray;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) UILabel * indexLabel;
@property (nonatomic, strong) UIButton * saveButton;


@end

@implementation LYMPhotoBrowser

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(NO, @"应该使用initWithTotalImageCount:current:方法初始化");
    }
    return self;
}

- (instancetype)initWithTotalImageCount:(NSInteger)totalCount current:(NSInteger)currentIndex delegate:(id<LYMPhotoBrowserDelegate> _Nullable)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = LYMPhotoBrowserBackgrounColor;
        self.imageViewMuArray = [NSMutableArray arrayWithCapacity:10];
        self.imageCount = totalCount;
        self.currentImageIndex = currentIndex;
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithPhotosURL:(NSArray<NSURL *> *)photosURL current:(NSInteger)currentIndex {
    self = [self initWithTotalImageCount:photosURL.count current:currentIndex delegate:nil];
    if (self) {
        self.defaultImageURLArr = photosURL;
    }
    return self;
}

- (void)dealloc {
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
    NSLog(@"%@ 相册控件销毁", NSStringFromClass([self class]));
}

#pragma mark - Construct
- (void)constructScrollView {
    
    self.mainScrollView = [[UIScrollView alloc] init];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.pagingEnabled = YES;
    [self addSubview:self.mainScrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        LYMPhotoBrowserOnePhotoScrollView * onePhotoView = [[LYMPhotoBrowserOnePhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        onePhotoView.browserDelegate = self;
        onePhotoView.currentIndex = i;
        
        [self.mainScrollView addSubview:onePhotoView];
        [self.imageViewMuArray addObject:onePhotoView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

- (void)constructToolbars {
    // 当前照片在相册中的位置
    _indexLabel = [UIInsetableLabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter textInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    _indexLabel.bounds = CGRectMake(0, 0, 80, 25);
    _indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_indexLabel setupCornerRadius:_indexLabel.height * 0.5];
    [self addSubview:_indexLabel];
    [_indexLabel setTextAndAdjustWidth:[NSString stringWithFormat:@"%ld/%ld", (long)self.currentImageIndex + 1, (long)self.imageCount]];
    
    // 保存按钮
    _saveButton = [[UIButton alloc] init];
    _saveButton.bounds = CGRectMake(0, 0, 100, 100);
    [_saveButton setupCornerRadius:_saveButton.height * 0.5];
    [_saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveButton];
    
    UILabel * saveButtonLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [_saveButton addSubview:saveButtonLabel];
    saveButtonLabel.text = @"保存";
    saveButtonLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    saveButtonLabel.bounds = CGRectMake(0, 0, 55, 30);
    [saveButtonLabel setXToCenterHorizontally];
    [saveButtonLabel setYToCenterVertically];
    [saveButtonLabel setupCornerRadius:saveButtonLabel.height * 0.5];
}


#pragma mark - Public methods
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
    
    [self constructScrollView];
    [self constructToolbars];
    [self reloadUI];
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)removeFromSuperview {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [super removeFromSuperview];
}

- (void)setImageIndexLabelHidden:(BOOL)isHidden {
    NSAssert(_indexLabel != nil, @"必须要在调用show方法后才能调用此方法(%s)", __func__);
    _indexLabel.hidden = isHidden;
}

- (void)setSaveButtonHidden:(BOOL)isHidden {
    NSAssert(_saveButton != nil, @"必须要在调用show方法后才能调用此方法(%s)", __func__);
    _saveButton.hidden = isHidden;
}

#pragma mark - Private methods
//保存到相机胶卷
- (void)saveImage {
    int index = self.mainScrollView.contentOffset.x / self.mainScrollView.bounds.size.width;
    LYMPhotoBrowserOnePhotoScrollView * currentPhotoScrollView = self.imageViewMuArray[index];
    UIImageWriteToSavedPhotosAlbum(currentPhotoScrollView.mainImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    [SVProgressHUD showWithStatus:LYMPhotoBrowserSaveingImage];
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index {
    LYMPhotoBrowserOnePhotoScrollView *imageView = self.imageViewMuArray[index];
    self.currentImageIndex = index;
    //如果已经加载过，则不再加载
    if (imageView.hasLoadedImage) {
        return;
    }
    UIImage * placeHolderImage = [self placeholderImageForIndex:index];
    NSURL * highQualityImageURL = [self highQualityImageURLForIndex:index];
    [imageView setImageWithURL:nil placeholderImage:placeHolderImage];
    if (highQualityImageURL) {
        [imageView setImageWithURL:highQualityImageURL placeholderImage:placeHolderImage];
    }
}

- (void)reloadUI {
    //父容器左右留出一点空间，用于分隔不同的页。显示每页时，两端的黑边正好在屏幕外
    CGRect rect = self.bounds;
    rect.size.width += LYMPhotoBrowserImageViewMargin * 2;
    self.mainScrollView.bounds = rect;
    self.mainScrollView.center = self.center;
    
    [self.imageViewMuArray enumerateObjectsUsingBlock:^(LYMPhotoBrowserOnePhotoScrollView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = LYMPhotoBrowserImageViewMargin + idx * (LYMPhotoBrowserImageViewMargin * 2 + obj.width);
        obj.x = x;
    }];
    //根据子视图数量，设置contentSize大小
    self.mainScrollView.contentSize = CGSizeMake(self.imageViewMuArray.count * self.mainScrollView.frame.size.width, 0);
    self.mainScrollView.contentOffset = CGPointMake(self.currentImageIndex * self.mainScrollView.frame.size.width, 0);
    
    if (!_hasShowedFirstView) {
        [self showFirstImage];
    }
    
    _indexLabel.y = 20;
    [_indexLabel setXToCenterHorizontally];
    _saveButton.x = 0;
    _saveButton.bottomMargin = 0;
}

- (void)showFirstImage {
    UIView *sourceView = nil;
    if ([self.delegate respondsToSelector:@selector(photoBrowser:animationViewForIndex:)]) {
        sourceView = [self.delegate photoBrowser:self animationViewForIndex:self.currentImageIndex];
    }
    UIImage * beginnerImage = [self placeholderImageForIndex:self.currentImageIndex];
    //如果beginnerView设置为nil，则从屏幕中间起始动画
    CGRect rect = CGRectMake(ScreenWidth * 0.5, ScreenHeight * 0.5, 0, 0);
    if (sourceView) {
        rect = [sourceView.superview convertRect:sourceView.frame toView:self];
    }
    UIImageView *tempView = [[UIImageView alloc] init];
    [self addSubview:tempView];
    tempView.image = beginnerImage;
    tempView.frame = rect;
    tempView.contentMode = [self.imageViewMuArray[self.currentImageIndex].mainImageView contentMode];
    tempView.clipsToBounds = YES;
    self.mainScrollView.hidden = YES;
    
    //有动画
    [UIView animateWithDuration:LYMPhotoBrowserShowImageAnimationDuration animations:^{
        if (beginnerImage.size.width != 0) {
            tempView.height = ScreenWidth * (beginnerImage.size.height / beginnerImage.size.width);
        } else {
            tempView.height = ScreenHeight;
        }
        tempView.width = ScreenWidth;
        [tempView setYToCenterVertically];
        tempView.x = 0;
    } completion:^(BOOL finished) {
        _hasShowedFirstView = YES;
        [tempView removeFromSuperview];
        self.mainScrollView.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    } else {
        //通过代理拿不到图片url，则尝试使用初始化时的url数组
        if (index < _defaultImageURLArr.count) {
            return _defaultImageURLArr[index];
        }
    }
    return nil;
}

#pragma mark - Callback
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        LYMPhotoBrowserOnePhotoScrollView *currentImageView = self.imageViewMuArray[_currentImageIndex];
        if ([currentImageView isKindOfClass:[LYMPhotoBrowserOnePhotoScrollView class]]) {
            [currentImageView eliminateScale];
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:LYMPhotoBrowserSaveImageFailText];
    }   else {
        [SVProgressHUD showSuccessWithStatus:LYMPhotoBrowserSaveImageSuccessText];
    }
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = (scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        LYMPhotoBrowserOnePhotoScrollView *imageView = self.imageViewMuArray[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    
    [_indexLabel setTextAndAdjustWidth:[NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount]];
    [self setupImageOfImageViewForIndex:index];
}

#pragma mark - Browser ImageView delegate
- (void)oneScrollView:(LYMPhotoBrowserOnePhotoScrollView *)scrollView downloadWithURL:(NSURL *)url image:(UIImage *)image {
    if (image && url) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:imageDownloadComplete:withURL:atIndex:)]) {
            [self.delegate photoBrowser:self imageDownloadComplete:image withURL:url atIndex:scrollView.currentIndex];
        }
    }
}

- (void)oneScrollView:(LYMPhotoBrowserOnePhotoScrollView *)scrollView didTap:(UITapGestureRecognizer *)tapGesture {
    _saveButton.hidden = YES;
    self.mainScrollView.hidden = YES;
    
    UIView *sourceView = nil;
    if ([self.delegate respondsToSelector:@selector(photoBrowser:animationViewForIndex:)]) {
        sourceView = [self.delegate photoBrowser:self animationViewForIndex:self.currentImageIndex];
    }
    
    UIImageView * tempView = [[UIImageView alloc] init];
    [self addSubview:tempView];
    tempView.image = scrollView.mainImageView.image;
    tempView.contentMode = scrollView.mainImageView.contentMode;
    tempView.clipsToBounds = YES;
    CGFloat tempViewHeight = scrollView.height;
    if (tempView.image.size.width != 0.0) {
        tempViewHeight = scrollView.width * (tempView.image.size.height / tempView.image.size.width);
    }
    tempView.bounds = CGRectMake(0, 0, scrollView.width, tempViewHeight);
    tempView.center = self.mainScrollView.center;
    //没有实现animationBeginnerView代理，就默认回到屏幕中间
    CGRect animEndRect = CGRectMake(ScreenWidth * 0.5, ScreenHeight * 0.5, 0, 0);
    if (sourceView) {
        animEndRect = [sourceView.superview convertRect:sourceView.frame toView:self];
    }
    //动画过渡界面
    [UIView animateWithDuration:LYMPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = animEndRect;
        self.backgroundColor = [UIColor clearColor];
        _indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
