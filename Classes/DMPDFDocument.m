#import "DMPDFDocument.h"
#import "DMPDFPage.h"


@implementation DMPDFDocument

- (instancetype)initWithUrl:(NSURL*)url {
    if(self = [super init]) {
        self.reference = CGPDFDocumentCreateWithURL((__bridge CFURLRef) url);
        self.numberOfPages = CGPDFDocumentGetNumberOfPages(self.reference);
        NSMutableArray* pages = [NSMutableArray arrayWithCapacity:self.numberOfPages];
        for (NSUInteger pageNumber = 1; pageNumber <= self.numberOfPages; pageNumber++) {
            [pages addObject:[[DMPDFPage alloc] initWithReference:CGPDFDocumentGetPage(self.reference, pageNumber) andDocument:self]];
        }
        self.pages = [NSArray arrayWithArray:pages];
    }
    return self;
}

#pragma mark - NSObject

- (void)dealloc {
    if(self.reference) {
        CGPDFDocumentRelease(self.reference);
    }
}

@end