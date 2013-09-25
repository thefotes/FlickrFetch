//
//  PFFlickrPhotoModel.m
//  FlickrStream
//
//  Created by Peter Foti on 9/25/13.
//  Copyright (c) 2013 Peter Foti. All rights reserved.
//

#import "PFFlickrPhotoModel.h"

@implementation PFFlickrPhotoModel

- (NSDictionary *)jsonFile
{
    if (!_jsonFile) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"flickr-response" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _jsonFile = [NSJSONSerialization JSONObjectWithData:data
                                                    options:0
                                                      error:nil];
    }
    
    return _jsonFile;
}
@end
