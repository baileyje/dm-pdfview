#import "DMPDFView.h"
#import "DMPDFPageView.h"
#import "DMPDFUtils.h"

#define DMPDFPageMargin 10.0
#define DMPDFZoomMin 1.0
#define DMPDFZoomMax 5.0
#define DMPDFZoomInc 1.0
#define DMPDFPageBuffer 2

@interface DMPDFPageReference : NSObject
@property (nonatomic) CGPDFPageRef page;
@property (nonatomic) CGSize pageSize;
@property (nonatomic, strong) DMPDFPageView* view;
@end

@interface DMPDFView() <UIScrollViewDelegate>
@property (nonatomic) CGPDFDocumentRef document;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) NSArray*pages;
@end

@implementation DMPDFView {
    NSInteger currentPage;
}

- (void)initialize {
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

- (void)load:(NSURL*)pdfUrl {
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((__bridge CFURLRef) pdfUrl);
    int numPages = CGPDFDocumentGetNumberOfPages(document);
    NSMutableArray* pageViews = [NSMutableArray arrayWithCapacity:numPages];
    for (int pageNumber = 1; pageNumber <= numPages; pageNumber++) {
        CGPDFPageRef page = CGPDFDocumentGetPage(document, (size_t) pageNumber);
        DMPDFPageReference* reference = [DMPDFPageReference new];
        reference.page = page;
        reference.pageSize = [DMPDFUtils pageSize:page];
        reference.view = [[DMPDFPageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) page:page];;
        reference.view.layer.shadowOffset = CGSizeMake(3, 3);
        reference.view.layer.shadowColor = [UIColor blackColor].CGColor;
        reference.view.layer.shadowOpacity = .5;
        [self.containerView addSubview:reference.view];
        [pageViews addObject:reference];
    }
    self.pages = [NSArray arrayWithArray:pageViews];
    [self setNeedsLayout];
}

- (void)clearContent {
    for(UIView* subview in self.containerView.subviews) {
        [subview removeFromSuperview];
    }
    self.containerView.frame = CGRectZero;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.pages = nil;
    if(self.document) {
        CGPDFDocumentRelease(self.document);
    }
}

 - (void)renderPages {
     int start = MAX(currentPage - DMPDFPageBuffer, 0);
     int end = MIN(self.pages.count - 1, currentPage + DMPDFPageBuffer);
     NSLog(@"Current: %d  Start: %d  End: %d", currentPage, start, end);
     for (NSUInteger i = 0; i < self.pages.count; i++) {
         DMPDFPageReference* item = self.pages[i];
         if (i < start || i > end) {
             [item.view unload];
         } else {
             [item.view load];
         }
     };
 }

- (void)tapped:(UITapGestureRecognizer*)recognizer {
    NSLog(@"Single Tapped");
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

- (void)setCurrentPage:(NSUInteger)page {
    if(page != currentPage) {
        currentPage = page;
        [self renderPages];
    }
}

- (NSUInteger)pageForContentOffset {
    CGFloat offset = MAX(self.scrollView.contentOffset.y, DMPDFPageMargin);
    NSUInteger idx = 0;
    for(DMPDFPageReference* reference in self.pages) {
        if(reference.view.frame.origin.y - DMPDFPageMargin > offset) {
            return MAX(0 ,idx -1);
        }
        idx++;
    }
    return self.pages.count - 1;;
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
    for(DMPDFPageReference* pageReference in self.pages) {
        CGSize pageSize = pageReference.pageSize;
        CGFloat scale = (self.frame.size.width - DMPDFPageMargin *2) / pageSize.width;
        pageReference.view.frame = CGRectMake(DMPDFPageMargin, offset, pageSize.width * scale, pageSize.height * scale);
        offset += pageReference.view.frame.size.height + DMPDFPageMargin;
    }
    self.containerView.frame = CGRectMake(0, 0, self.frame.size.width, offset);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, offset);
    [self renderPages];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView*)scrollView{
    [self setCurrentPage:[self pageForContentOffset]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    [self setCurrentPage:[self pageForContentOffset]];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    return self.containerView;
}

#pragma mark - NSObject

- (void)dealloc {
    if(self.document) {
        CGPDFDocumentRelease(self.document);
    }
}

@end

@implementation DMPDFPageReference
@end