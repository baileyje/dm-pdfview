#import "DMPDFPageView.h"
#import "DMPDFPage.h"
#import "DMPDFView.h"

@interface DMPDFPageView ()
@property (nonatomic, strong) DMPDFPage* page;
@property (nonatomic) DMPDFRenderQuality renderQuality;
- (void)doRender;
- (void)doClear;
@end

@implementation DMPDFPageView

- (instancetype)initWithFrame:(CGRect)frame page:(DMPDFPage*)page renderQuality:(DMPDFRenderQuality)quality {
    if(self = [super initWithFrame:frame]) {
        self.page = page;
        self.renderQuality = quality;
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