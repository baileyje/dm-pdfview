#import "DMPDFPageView.h"
#import "DMPDFUtils.h"

@interface DMPDFPageView()
@property (nonatomic) CGPDFPageRef page;
@end

@implementation DMPDFPageView {
    BOOL loaded;
}

- (instancetype)initWithFrame:(CGRect)frame page:(CGPDFPageRef)page {
    if(self = [super initWithFrame:frame]) {
        self.page = page;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)load {
    if(!loaded) {
        loaded = YES;
        [self setNeedsDisplay];
    }
}

- (void)unload {
    if(loaded) {
        loaded = NO;
        [self setNeedsDisplay];
    }
}

#pragma mark - UIView

-(void)drawRect:(CGRect)rect {
}

-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context {
    if(loaded) [DMPDFUtils render:self.page into:context withSize:self.bounds.size];
}

@end
