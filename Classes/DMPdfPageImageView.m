#import "DMPdfPageImageView.h"
#import "DMPdfPage.h"
#import "DMPdfDocument.h"
#import "DMImageCache.h"

@interface DMPdfPageImageView ()
@property (nonatomic, strong) UIImageView* imageView;
@end


@implementation DMPdfPageImageView

+ (dispatch_queue_t)dispatchQueue {
    static dispatch_queue_t dispatchQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = dispatch_queue_create("com.devmode.pdf.image", NULL);
    });
    return dispatchQueue;
}

+ (DMImageCache*)imageCache {
    static DMImageCache* cache = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[DMImageCache alloc] initWithNamespace:@"com.devmode.pdf.page"];
        cache.cacheLimit = 25 * 1024 * 1024; // 25MB
    });
    return cache;
}

- (instancetype)initWithFrame:(CGRect)frame page:(DMPdfPage*)page renderQuality:(DMPdfRenderQuality)quality cache:(BOOL)cache {
    if(self = [super initWithFrame:frame page:page renderQuality:quality cache:cache]) {
        self.autoresizesSubviews = YES;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)doRender {
    __weak DMPdfPageImageView* _self = self;
    if(self.cache) {
        NSString* pageKey = [NSString stringWithFormat:@"%@-%d-%f-%f", self.page.document.url.absoluteString, self.page.number, self.frame.size.width, self.frame.size.height];
        [DMPdfPageImageView.imageCache imageForKey:pageKey callback:^(UIImage* image) {
            _self.imageView.image = image;
        } loader:^(DMImageCallback callback) {
            callback([_self.page asImageWithSize:_self.renderSize]);
        }];
    } else {
        dispatch_async(DMPdfPageImageView.dispatchQueue, ^{
            UIImage* image = [_self.page asImageWithSize:_self.renderSize];
            dispatch_async(dispatch_get_main_queue(), ^{
                _self.imageView.image = image;
            });
        });
    }
}

- (void)doClear {
    self.imageView.image = nil;
}

@end