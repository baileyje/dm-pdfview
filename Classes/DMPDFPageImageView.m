#import "DMPDFPageImageView.h"
#import "DMPDFUtils.h"

@interface DMPDFPageImageView()
@property (nonatomic, strong) UIImageView* imageView;
@end


@implementation DMPDFPageImageView

- (instancetype)initWithFrame:(CGRect)frame page:(CGPDFPageRef)page {
    if(self = [super initWithFrame:frame]) {
        self.autoresizesSubviews = YES;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imageView];
        @autoreleasepool {
            self.imageView.image = [DMPDFUtils renderImage:page withSize:frame.size];
        }
        self.pageSize = [DMPDFUtils pageSize:page];
    }
    return self;
}

@end