//
//  OMHSerializerLocation.h
//  Pods
//
//  Created by Anders Borch on 4/4/17.
//
//

#import "OMHSerializer.h"
@import CoreLocation;

@interface OMHSerializerLocation : OMHSerializer

- (instancetype)initWithLocation:(CLLocation*)location;
- (NSString*)jsonForLocation:(CLLocation*)sample error:(NSError**)error;
- (NSDictionary*)dictionaryForLocation:(CLLocation*)sample error:(NSError**)error;

@end
