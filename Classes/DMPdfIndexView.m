#import "DMPdfIndexView.h"
#import "DMPdfPageImageView.h"
#import "DMPdfDocument.h"
#import "DMPdfPage.h"

#define DMPdfIndexPageMargin 15.0
#define DMPdfIndexHighlightBoost 15.0

@interface DMPdfIndexPageTap : UITapGestureRecognizer
@property (nonatomic) NSUInteger page;
@end

@interface DMPdfIndexView ()
@property (nonatomic, strong) NSArray* pages;
@property (nonatomic, strong) UIView* current;
@property (nonatomic, strong) UIScrollView* scrollView;
@end

@implementation DMPdfIndexView


- (instancetype)initWithFrame:(CGRect)frame andDocument:(DMPdfDocument*)document cachePages:(BOOL)cache {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:.8];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;

        UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, frame.size.height)];
        divider.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.8];
        divider.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:divider];

        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.scrollView];
        NSMutableArray* pages = [NSMutableArray arrayWithCapacity:document.numberOfPages];
        CGFloat offset = DMPdfIndexPageMargin;
        for (DMPdfPage* page in document.pages) {
            CGFloat scale = (self.frame.size.width - DMPdfIndexPageMargin *2) / page.size.width;
            CGRect thumbFrame = CGRectMake(DMPdfIndexPageMargin, offset, page.size.width * scale, page.size.height * scale);
            DMPdfPageImageView* pageView = [[DMPdfPageImageView alloc] initWithFrame:thumbFrame page:page renderQuality:DMPdfRenderQualityHigh cache:cache];
            [pageView render];
            DMPdfIndexPageTap* recognizer = [[DMPdfIndexPageTap alloc] initWithTarget:self action:@selector(pageTapped:)];
            recognizer.page = page.number - 1;
            [pageView addGestureRecognizer:recognizer];
            pageView.layer.borderColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.8].CGColor;
            pageView.layer.borderWidth = 1;
            [self.scrollView addSubview:pageView];
            [pages addObject:pageView];
            offset += thumbFrame.size.height + DMPdfIndexPageMargin;
        }
        self.pages = [NSArray arrayWithArray:pages];
        self.scrollView.contentSize = CGSizeMake(frame.size.width, offset);
        if(offset < frame.size.height) {
            self.scrollView.frame = CGRectMake(0, (frame.size.height - offset) / 2, frame.size.width, offset);
        }
    }
    return self;
}

- (void)highlight:(NSUInteger)page {
    [UIView animateWithDuration:.5 animations:^{
        if(self.current) {
            CGRect currentFrame = self.current.frame;
            self.current.frame = CGRectMake(currentFrame.origin.x + DMPdfIndexHighlightBoost/2.0, currentFrame.origin.y + DMPdfIndexHighlightBoost/2.0, currentFrame.size.width - DMPdfIndexHighlightBoost, currentFrame.size.height - DMPdfIndexHighlightBoost);
        }
        self.current = self.pages[page];
        CGRect frame = self.current.frame;
        self.current.frame = CGRectMake(frame.origin.x - DMPdfIndexHighlightBoost/2.0, frame.origin.y - DMPdfIndexHighlightBoost/2.0, frame.size.width + DMPdfIndexHighlightBoost, frame.size.height + DMPdfIndexHighlightBoost);
        [self.scrollView scrollRectToVisible:self.current.frame animated:YES];
    }];

}

- (void)pageTapped:(DMPdfIndexPageTap*)gesture {
    if(self.delegate) {
        [self.delegate indexPageSelected:gesture.page];
    }
}

@end

@implementation DMPdfIndexPageTap
@end