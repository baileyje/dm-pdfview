#import <CoreGraphics/CoreGraphics.h>
#import "DMPDFIndexView.h"
#import "DMPDFUtils.h"
#import "DMPDFPageImageView.h"

#define DMPDFIndexPageMargin 15.0
#define DMPDFIndexHighlightBoost 15.0

@interface DMPDFIndexPageTap : UITapGestureRecognizer
@property (nonatomic) NSUInteger page;
@end

@interface DMPDFIndexView()
@property (nonatomic, strong) NSArray* pages;
@property (nonatomic, strong) UIView* current;
@end

@implementation DMPDFIndexView


- (instancetype)initWithFrame:(CGRect)frame andDocument:(CGPDFDocumentRef)document {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:.8];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;

        UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, frame.size.height)];
        divider.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.8];
        divider.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:divider];

        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:scrollView];
        size_t numPages = CGPDFDocumentGetNumberOfPages(document);
        NSMutableArray* pages = [NSMutableArray arrayWithCapacity:numPages];
        CGFloat offset = DMPDFIndexPageMargin;
        for (size_t pageNumber = 1; pageNumber <= numPages; pageNumber++) {
            CGPDFPageRef page = CGPDFDocumentGetPage(document, pageNumber);
            CGSize pageSize = [DMPDFUtils pageSize:page];
            CGFloat scale = (self.frame.size.width - DMPDFIndexPageMargin *2) / pageSize.width;
            CGRect thumbFrame = CGRectMake(DMPDFIndexPageMargin, offset, pageSize.width * scale, pageSize.height * scale);
            DMPDFPageImageView* pageView = [[DMPDFPageImageView alloc] initWithFrame:thumbFrame page:page];
            DMPDFIndexPageTap* recognizer = [[DMPDFIndexPageTap alloc] initWithTarget:self action:@selector(pageTapped:)];
            recognizer.page = pageNumber - 1;
            [pageView addGestureRecognizer:recognizer];
            pageView.layer.borderColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.8].CGColor;
            pageView.layer.borderWidth = 1;
            [scrollView addSubview:pageView];
            [pages addObject:pageView];
            offset += thumbFrame.size.height + DMPDFIndexPageMargin;
        }
        self.pages = [NSArray arrayWithArray:pages];
        scrollView.contentSize = CGSizeMake(frame.size.width, offset);
        if(offset < frame.size.height) {
            scrollView.frame = CGRectMake(0, (frame.size.height - offset) / 2, frame.size.width, offset);
        }
    }
    return self;
}

- (void)highlight:(NSUInteger)page {
    if(self.current) {
        CGRect currentFrame = self.current.frame;
        self.current.frame = CGRectMake(currentFrame.origin.x + DMPDFIndexHighlightBoost/2.0, currentFrame.origin.y + DMPDFIndexHighlightBoost/2.0, currentFrame.size.width - DMPDFIndexHighlightBoost, currentFrame.size.height - DMPDFIndexHighlightBoost);
    }
    self.current = self.pages[page];
    CGRect frame = self.current.frame;
    self.current.frame = CGRectMake(frame.origin.x - DMPDFIndexHighlightBoost/2.0, frame.origin.y - DMPDFIndexHighlightBoost/2.0, frame.size.width + DMPDFIndexHighlightBoost, frame.size.height + DMPDFIndexHighlightBoost);
}

- (void)pageTapped:(DMPDFIndexPageTap*)gesture {
    if(self.delegate) {
        [self.delegate indexPageSelected:gesture.page];
    }
}

@end

@implementation DMPDFIndexPageTap
@end