#import "DMPdfPageImageView.h"
#import "DMPdfPage.h"
#import "DMPdfView.h"

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

- (instancetype)initWithFrame:(CGRect)frame page:(DMPdfPage*)page renderQuality:(DMPdfRenderQuality)quality {
    if(self = [super initWithFrame:frame page:page renderQuality:quality]) {
        self.autoresizesSubviews = YES;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)doRender {
    __weak DMPdfPageImageView* _self = self;
    dispatch_async(DMPdfPageImageView.dispatchQueue, ^{
        UIImage* image = [_self.page asImageWithSize:_self.renderSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            _self.imageView.image = image;
        });
    });
}

- (void)doClear {
    self.imageView.image = nil;
}

@end