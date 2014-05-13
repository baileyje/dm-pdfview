#import "DMPdfPageView.h"
#import "DMPdfPage.h"
#import "DMPdfView.h"

@interface DMPdfPageView ()
@property (nonatomic, strong) DMPdfPage* page;
@property (nonatomic) DMPdfRenderQuality renderQuality;
@property (nonatomic) BOOL cache;
- (void)doRender;
- (void)doClear;
@end

@implementation DMPdfPageView

- (instancetype)initWithFrame:(CGRect)frame page:(DMPdfPage*)page renderQuality:(DMPdfRenderQuality)quality cache:(BOOL)cache {
    if(self = [super initWithFrame:frame]) {
        self.page = page;
        self.renderQuality = quality;
        self.cache = cache;
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)render {
    if(!loaded) {
        loaded = YES;
        [self doRender];
    }
}

- (void)clear {
    if(loaded) {
        loaded = NO;
        [self doClear];
    }
}

- (CGSize)renderSize {
    CGFloat scale = 1.0 - self.renderQuality * .25;
    return CGSizeMake(self.frame.size.width * scale, self.frame.size.height * scale);
}

- (void)doRender {
    [self setNeedsDisplay];
}

- (void)doClear {
    [self setNeedsDisplay];
}

@end