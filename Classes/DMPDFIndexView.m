#import "DMPDFIndexView.h"
#import "DMPDFPageImageView.h"
#import "DMPDFDocument.h"
#import "DMPDFPage.h"
#import "DMPDFView.h"

#define DMPDFIndexPageMargin 15.0
#define DMPDFIndexHighlightBoost 15.0

@interface DMPDFIndexPageTap : UITapGestureRecognizer
@property (nonatomic) NSUInteger page;
@end

@interface DMPDFIndexView()
@property (nonatomic, strong) NSArray* pages;
@property (nonatomic, strong) UIView* current;
@property (nonatomic, strong) UIScrollView* scrollView;
@end

@implementation DMPDFIndexView


- (instancetype)initWithFrame:(CGRect)frame andDocument:(DMPDFDocument*)document {
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
        CGFloat offset = DMPDFIndexPageMargin;
        for (DMPDFPage* page in document.pages) {
            CGFloat scale = (self.frame.size.width - DMPDFIndexPageMargin *2) / page.size.width;
            CGRect thumbFrame = CGRectMake(DMPDFIndexPageMargin, offset, page.size.width * scale, page.size.height * scale);
            DMPDFPageImageView* pageView = [[DMPDFPageImageView alloc] initWithFrame:thumbFrame page:page renderQuality:DMPDFRenderQualityHigh];
            [pageView render];
            DMPDFIndexPageTap* recognizer = [[DMPDFIndexPageTap alloc] initWithTarget:self action:@selector(pageTapped:)];
            recognizer.page = page.number - 1;
            [pageView addGestureRecognizer:recognizer];
            pageView.layer.borderColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.8].CGColor;
            pageView.layer.borderWidth = 1;
            [self.scrollView addSubview:pageView];
            [pages addObject:pageView];
            offset += thumbFrame.size.height + DMPDFIndexPageMargin;
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
            self.current.frame = CGRectMake(currentFrame.origin.x + DMPDFIndexHighlightBoost/2.0, currentFrame.origin.y + DMPDFIndexHighlightBoost/2.0, currentFrame.size.width - DMPDFIndexHighlightBoost, currentFrame.size.height - DMPDFIndexHighlightBoost);
        }
        self.current = self.pages[page];
        CGRect frame = self.current.frame;
        self.current.frame = CGRectMake(frame.origin.x - DMPDFIndexHighlightBoost/2.0, frame.origin.y - DMPDFIndexHighlightBoost/2.0, frame.size.width + DMPDFIndexHighlightBoost, frame.size.height + DMPDFIndexHighlightBoost);
        [self.scrollView scrollRectToVisible:self.current.frame animated:YES];
    }];

}

- (void)pageTapped:(DMPDFIndexPageTap*)gesture {
    if(self.delegate) {
        [self.delegate indexPageSelected:gesture.page];
    }
}

@end

@implementation DMPDFIndexPageTap
@end