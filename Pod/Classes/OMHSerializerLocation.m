//
//  OMHSerializerLocation.m
//  Pods
//
//  Created by Anders Borch on 4/4/17.
//
//

#import "OMHSerializerLocation.h"
#import "NSDate+RFC3339.h"
#import "ORKSample.h"

@interface OMHSerializer()
- (id)initWithSample:(HKSample*)sample;
- (id)data;
@end

@interface OMHSerializerLocation()
@property (nonatomic, retain) CLLocation* location;
@end


/**
 This serializer maps data from CLLocation samples to JSON that conforms to the Open mHealth [location schema](http://www.openmhealth.org/documentation/#/schema-docs/schema-library/schemas/location).
 */
@implementation OMHSerializerLocation

- (instancetype)initWithLocation:(CLLocation*)location {
    ORKSample *sample = [ORKSample sampleWithStartDate: location.timestamp
                                               endDate: location.timestamp];
    self = [super initWithSample: sample];
    if (self) {
        self.location = location;
    }
    return self;
}
    
/**
 Serializes CoreLocation samples into Open mHealth compliant JSON data points.
 @param sample the CoreLocation object to be serialized
 @param error an NSError that is passed by reference and can be checked to identify specific errors
 @return a formatted JSON string containing the sample's data in a format that adheres to the appropriate Open mHealth schema
 */

- (NSString*)jsonForLocation:(CLLocation*)sample error:(NSError**)error {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionaryForLocation:sample error:error]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:error];
    if (*error) {
        NSLog(@"Error serializing data: %@", *error);
        return nil; // return early if JSON serialization failed
    }
    NSString* jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
    
}

- (NSDictionary*)dictionaryForLocation:(CLLocation*)sample error:(NSError**)error {
    NSParameterAssert(sample);
    // first, verify we support the sample type
    NSString* serializerClassName = @"OMHSerializerStepCount";
    // if we support it, select appropriate subclass for sample
    
    Class serializerClass = NSClassFromString(serializerClassName);
    // subclass verifies it supports sample's values
    if (![serializerClass canSerialize:sample error:error]) {
        return nil;
    }
    // instantiate a serializer
    OMHSerializerLocation* serializer = [[serializerClass alloc] initWithLocation:sample];
    return [serializer data];
}

+ (BOOL)canSerialize:(CLLocation*)sample error:(NSError**)error {
    return YES;
}
- (id)bodyData {
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    return @{
             @"latitude": [NSNumber numberWithDouble:self.location.coordinate.latitude],
             @"longitude": [NSNumber numberWithDouble:self.location.coordinate.longitude],
             @"accuracy": [NSNumber numberWithDouble:self.location.horizontalAccuracy],
             @"sensing_date_time": [self.location.timestamp RFC3339StringAtTimeZone:timeZone]
             };
}
- (NSString*)schemaName {
    return @"location";
}
- (NSString*)schemaVersion {
    return @"1.0";
}
- (NSString*)schemaNamespace {
    return @"ork";
}
@end

