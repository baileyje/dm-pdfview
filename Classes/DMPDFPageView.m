#import "DMPDFPageView.h"
#import "DMPDFPage.h"

@interface DMPDFPageView ()
@property (nonatomic, strong) DMPDFPage* page;
- (void)doLoad;
- (void)doUnload;
@end

@implementation DMPDFPageView

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
        [self doLoad];
    }
}

- (void)unload {
    if(loaded) {
        loaded = NO;
        [self doUnload];
    }
}

- (void)doLoad {
    [self setNeedsDisplay];
}

- (void)doUnload {
    [self setNeedsDisplay];
}

@end