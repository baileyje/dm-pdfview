#import "DMPDFPageView.h"
#import "DMPDFPage.h"
#import "DMPDFView.h"

@interface DMPDFPageView ()
@property (nonatomic, strong) DMPDFPage* page;
@property (nonatomic) DMPDFRenderQuality renderQuality;
- (void)doLoad;
- (void)doUnload;
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
        [self doLoad];
    }
}

- (void)clear {
    if(loaded) {
        loaded = NO;
        [self doUnload];
    }
}

- (CGSize)renderSize {
    CGFloat scale = 1.0 - self.renderQuality * .25;
    return CGSizeMake(self.frame.size.width * scale, self.frame.size.height * scale);
}

- (void)doLoad {
    [self setNeedsDisplay];
}

- (void)doUnload {
    [self setNeedsDisplay];
}

@end