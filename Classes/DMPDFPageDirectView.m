#import "DMPDFPageDirectView.h"
#import "DMPDFPage.h"


@implementation DMPDFPageDirectView

#pragma mark - UIView

-(void)drawRect:(CGRect)rect {
}

-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context {
    if(loaded) [self.page renderInto:context withSize:self.renderSize];
}

@end
