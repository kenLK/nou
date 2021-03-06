
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RADataObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *backgroundColor;
@property (strong, nonatomic) NSString *textColor;
@property (strong, nonatomic) NSString *borderColor;
@property (strong, nonatomic) NSString *marginTop;

@property (strong, nonatomic) NSArray *columnAlign;
@property (strong, nonatomic) NSArray *columnWidth;

@property (strong, nonatomic) NSString *docUrl;

@property (strong, nonatomic) NSString *googleMap;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSArray *multiLocation;
@property (strong, nonatomic) NSArray *multiAddr;
@property (strong, nonatomic) NSArray *multiSnippet;
@property (strong, nonatomic) NSArray *multiTitle;
@property (strong, nonatomic) NSString *zoom;

@property BOOL isLogo;
@property BOOL isMultiLine;
@property BOOL isChildDefaultExpanded;
@property BOOL isNotSelective;
@property BOOL callMapApp;

@property CGFloat multiLineHeight;


//@property (strong, nonatomic) NSString *BACKGROUND_COLOR;
@property (strong, nonatomic) NSArray *children;

- (id)initWithName:(NSString *)name children:(NSArray *)array;

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;

@end
