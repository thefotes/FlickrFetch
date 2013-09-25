//
//  PFFlickrPhoto.h
//  FlickrStream
//
//  Created by Peter Foti on 9/25/13.
//  Copyright (c) 2013 Peter Foti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFFlickrPhoto : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, strong) UIImage *image;

@end
