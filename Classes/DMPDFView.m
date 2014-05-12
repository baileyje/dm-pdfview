#import <QuartzCore/QuartzCore.h>
#import "DMPDFView.h"
#import "DMPDFPageDirectView.h"
#import "DMPDFIndexView.h"
#import "DMPDFDocument.h"
#import "DMPDFPage.h"
#import "DMPDFPageImageView.h"

#define DMPDFPageMargin 10.0
#define DMPDFZoomMin 1.0
#define DMPDFZoomMax 5.0
#define DMPDFZoomInc 1.0
#define DMPDFPageBuffer 5
#define DMPDFIndexWidth 100

@interface DMPDFView() <UIScrollViewDelegate, DMPDFIndexViewDelegate>
@property (nonatomic, strong) DMPDFDocument* document;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) NSArray* pages;
@property (nonatomic, strong) UILabel* pageLabel;
@property (nonatomic, strong) DMPDFIndexView* indexView;
@end

@implementation DMPDFView

- (void)load:(NSURL*)pdfUrl {
    self.document = [[DMPDFDocument alloc] initWithUrl:pdfUrl];
    NSMutableArray* pageViews = [NSMutableArray arrayWithCapacity:self.document.numberOfPages];
    CGFloat offset = DMPDFPageMargin;
    for (DMPDFPage* page in self.document.pages) {
        DMPDFPageView* pageView = [[DMPDFPageImageView alloc] initWithFrame:CGRectMake(0, offset, self.frame.size.width, self.frame.size.height) page:page renderQuality:self.renderQuality];
        pageView.layer.shadowOffset = CGSizeMake(3, 3);
        pageView.layer.shadowColor = [UIColor blackColor].CGColor;
        pageView.layer.shadowOpacity = .5;
        pageView.layer.borderColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.8].CGColor;
        pageView.layer.borderWidth = 1;
        [self.containerView addSubview:pageView];
        [pageViews addObject:pageView];
        offset += pageView.frame.size.height + DMPDFPageMargin;
    }
    self.pages = [NSArray arrayWithArray:pageViews];
    if(self.showsIndex) {
        self.indexView = [[DMPDFIndexView alloc] initWithFrame:CGRectMake(self.frame.size.width - self.indexWidth, 0, self.indexWidth, self.frame.size.height) andDocument:self.document];
        self.indexView.delegate = self;
        [self addSubview:self.indexView];
        [self.indexView highlight:self.currentPage];
        self.indexVisible = YES;
    }
    if(self.showsPageNumber) {
        self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 45, 80, 30)];
        self.pageLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        self.pageLabel.textColor = UIColor.whiteColor;
        self.pageLabel.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.7];
        self.pageLabel.layer.cornerRadius = 10;
        self.pageLabel.clipsToBounds = YES;
        self.pageLabel.textAlignment = NSTextAlignmentCenter;
        self.pageLabel.alpha = 0;
        [self addSubview:self.pageLabel];
        self.pageNumberVisible = NO;
        [self updatePageNumber];
    }
}

- (void)cleanup {
    for(UIView* subview in self.containerView.subviews) {
        [subview removeFromSuperview];
    }
    self.containerView.frame = CGRectZero;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.pages = nil;
    self.document = nil;
    if(self.pageLabel) {
        [self.pageLabel removeFromSuperview];
        self.pageLabel = nil;
    }
    self.pageLabel.hidden = YES;
    if(self.indexView) {
        [self.indexView removeFromSuperview];
        self.indexView = nil;
    }
}

- (void)renderPages {
    NSUInteger pageMargin = self.pageBuffer / 2;
    NSUInteger start = (NSUInteger) MAX((NSInteger)self.currentPage - (NSInteger)pageMargin, 0);
    NSUInteger end = MIN(self.pages.count - 1, self.currentPage + pageMargin);
    for (NSUInteger i = 0; i < self.pages.count; i++) {
        DMPDFPageView* pageView = self.pages[i];
        if (i < start || i > end) {
            [pageView clear];
        } else {
            [pageView render];
        }
    };
}

#pragma mark - Initialization

- (void)initialize {
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.showsIndex = YES;
    self.showsPageNumber = YES;
    self.indexWidth = DMPDFIndexWidth;
    self.pageBuffer = DMPDFPageBuffer;
    self.currentPage = 0;
    self.renderQuality = DMPDFRenderQualityHigh;
    [self initializeScrollview];
    [self initializeGestures];
}

- (void)initializeScrollview {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.minimumZoomScale = DMPDFZoomMin;
    self.scrollView.maximumZoomScale = DMPDFZoomMax;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delaysContentTouches = NO;
    [self addSubview:self.scrollView];
    self.containerView = [UIView new];
    [self.scrollView addSubview:self.containerView];
}

- (void)initializeGestures {
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTap];
    UITapGestureRecognizer* doubleMultiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    doubleMultiTap.numberOfTapsRequired = 2;
    doubleMultiTap.numberOfTouchesRequired = 2;
    [self addGestureRecognizer:doubleMultiTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

#pragma mark - Gestures

- (void)tapped:(UITapGestureRecognizer*)recognizer {
    [self toggleIndex];
}

- (void)doubleTapped:(UITapGestureRecognizer*)recognizer {
    CGFloat currentZoom = self.scrollView.zoomScale;
    if(recognizer.numberOfTouches == 1) {
        [self zoomTo:[recognizer locationInView:self.containerView] withScale:currentZoom + DMPDFZoomInc];
    } else if(recognizer.numberOfTouches == 2) {
        [self zoomTo:[recognizer locationInView:self.containerView] withScale:currentZoom - DMPDFZoomInc];
    }
}

- (void)zoomTo:(CGPoint)point withScale:(CGFloat)scale {
    CGFloat newScale = MAX(MIN(scale, self.scrollView.maximumZoomScale), self.scrollView.minimumZoomScale);
    CGSize scrollViewSize = self.scrollView.bounds.size;
    CGFloat width = scrollViewSize.width / newScale;
    CGFloat height = scrollViewSize.height / newScale;
    [self.scrollView zoomToRect:CGRectMake(point.x - (width / 2.0f), point.y - (height / 2.0f), width, height) animated:YES];
}

#pragma mark - Paging

- (void)setCurrentPage:(NSUInteger)page {
    _currentPage = page;
    [self updatePageNumber];
    if(self.indexView) {
        [self.indexView highlight:self.currentPage];
    }
    [self renderPages];
}

- (NSUInteger)pageForContentOffset {
    if(!self.pages.count) {
        return 0;
    }
    CGFloat offset = MAX(self.scrollView.contentOffset.y, DMPDFPageMargin);
    offset += self.frame.size.height / 2;
    NSUInteger idx = 0;
    for(DMPDFPageView* pageView in self.pages) {
        if(pageView.frame.origin.y - DMPDFPageMargin > offset) {
            return MAX(0 ,idx -1);
        }
        idx++;
    }
    return self.pages.count - 1;;
}

- (void)goto:(NSUInteger)page {
    [self goto:page animated:YES];
}

- (void)goto:(NSUInteger)page animated:(BOOL)animated {
    if(page != self.currentPage && page < self.pages.count) {
        DMPDFPageView* pageView = self.pages[page];
        if(pageView) {
            [self.scrollView setContentOffset:CGPointMake(0, pageView.frame.origin.y) animated:animated];
        }
    }
}

#pragma mark - Page Number

- (void)updatePageNumber {
    self.pageLabel.text = [NSString stringWithFormat:@"%d / %d", (int)self.currentPage + 1, (int)self.pages.count];
}

- (void)showPageNumber {
    if(!self.showsPageNumber || self.pageNumberVisible) return;
    self.pageNumberVisible = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:.5 animations:^{
        self.pageLabel.alpha = 1;
    }];
    [self performSelector:@selector(hidePageNumber) withObject:nil afterDelay:1.5];
}

- (void)hidePageNumber {
    if(!self.pageNumberVisible) return;
    self.pageNumberVisible = NO;
    [UIView animateWithDuration:.5 animations:^{
        self.pageLabel.alpha = 0;
    }];
}

#pragma mark - Index

- (void)toggleIndex {
    if(self.indexVisible) {
        [self hideIndex];
    } else {
        [self showIndex];
    }
}

- (void)showIndex {
    if(!self.showsIndex || self.indexVisible) return;
    self.indexVisible = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
         animations:^{
             CGRect indexFrame = self.indexView.frame;
             self.indexView.frame = CGRectMake(self.frame.size.width - indexFrame.size.width, indexFrame.origin.y, indexFrame.size.width, indexFrame.size.height);
         }
         completion:nil
    ];
    [self showPageNumber];
}

- (void)hideIndex {
    if(!self.indexVisible) return;
    self.indexVisible = NO;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
         animations:^{
             CGRect indexFrame = self.indexView.frame;
             self.indexView.frame = CGRectMake(self.frame.size.width, indexFrame.origin.y, indexFrame.size.width, indexFrame.size.height);
         }
         completion:nil
    ];
}


#pragma mark - DMPDFIndexViewDelegate

- (void)indexPageSelected:(NSUInteger)page {
    [self goto:page animated:NO];
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame  {
    if(self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {
    if ([super initWithCoder:coder]) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offset = DMPDFPageMargin;
    for(DMPDFPageView* pageView in self.pages) {
        CGSize pageSize = pageView.page.size;
        CGFloat scale = (self.frame.size.width - DMPDFPageMargin *2) / pageSize.width;
        pageView.frame = CGRectMake(DMPDFPageMargin, offset, pageSize.width * scale, pageSize.height * scale);
        offset += pageView.frame.size.height + DMPDFPageMargin;
    }
    self.containerView.frame = CGRectMake(0, 0, self.frame.size.width, offset);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, offset);
    [self renderPages];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    NSUInteger page = [self pageForContentOffset];
    if(page != self.currentPage) {
        [self setCurrentPage:page];
    }
    [self showPageNumber];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    return self.containerView;
}

@end