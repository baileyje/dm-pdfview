#import "DMPDFPageView.h"
#import "DMPDFUtils.h"
#import "DMPDFPage.h"

@interface DMPDFPageView()
@property (nonatomic, strong) DMPDFPage* page;
@end

@implementation DMPDFPageView {
    BOOL loaded;
}

- (instancetype)initWithFrame:(CGRect)frame andPage:(DMPDFPage*)page {
    if(self = [super initWithFrame:frame]) {
        self.page = page;
        self.backgroundColor = UIColor.whiteColor;
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
    if(loaded) [DMPDFUtils render:self.page.reference into:context withSize:self.bounds.size];
}

@end
