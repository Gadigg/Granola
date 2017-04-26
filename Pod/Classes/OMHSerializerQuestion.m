//
//  OMHSerializerQuestion.m
//  Pods
//
//  Created by Anders Borch on 4/24/17.
//
//

#import "OMHSerializerQuestion.h"
#import "ORKSample.h"
@import HealthKit;

@interface OMHSerializer()
- (id)initWithSample:(HKSample*)sample;
- (id)data;
@end

@interface OMHSerializerQuestion()
@property (nonatomic, retain) ORKQuestionResult* result;
@end

@implementation OMHSerializerQuestion

- (instancetype)initWithResult:(ORKQuestionResult*)result
{
    ORKSample *sample = [ORKSample sampleWithStartDate: result.startDate
                                               endDate: result.endDate];
    self = [super initWithSample: sample];
    if (self) {
        self.result = result;
    }
    return self;
}

/**
 Serializes ResearchKit question results into Open mHealth compliant JSON data points.
 @param sample the ResearchKit object to be serialized
 @param error an NSError that is passed by reference and can be checked to identify specific errors
 @return a formatted JSON string containing the sample's data in a format that adheres to the appropriate Open mHealth schema
 */
- (NSString*)jsonForResult:(ORKQuestionResult*)sample error:(NSError**)error {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionaryForResult:sample error:error]
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

- (NSDictionary*)dictionaryForResult:(ORKQuestionResult*)sample error:(NSError**)error {
    NSParameterAssert(sample);
    // first, verify we support the sample type
    // if we support it, select appropriate subclass for sample
    NSString* serializerClassName;
    switch (sample.questionType) {
//        case ORKQuestionTypeScale:
//            serializerClassName = @"OMHSerializerScaleQuestion";
//            break;
//        case ORKQuestionTypeSingleChoice:
//            serializerClassName = @"OMHSerializerSingleQuestion";
//            break;
//        case ORKQuestionTypeMultipleChoice:
//            serializerClassName = @"OMHSerializerMultipleQuestion";
//            break;
//        case ORKQuestionTypeDecimal:
//            serializerClassName = @"OMHSerializerDecimalQuestion";
//            break;
//        case ORKQuestionTypeInteger:
//            serializerClassName = @"OMHSerializerIntegerQuestion";
//            break;
//        case ORKQuestionTypeBoolean:
//            serializerClassName = @"OMHSerializerBooleanQuestion";
//            break;
        case ORKQuestionTypeText:
            serializerClassName = @"OMHSerializerTextQuestion";
            break;
//        case ORKQuestionTypeTimeOfDay:
//            serializerClassName = @"OMHSerializerTimeOfDayQuestion";
//            break;
//        case ORKQuestionTypeDateAndTime:
//            serializerClassName = @"OMHSerializerDateAndTimeQuestion";
//            break;
//        case ORKQuestionTypeDate:
//            serializerClassName = @"OMHSerializerDateQuestion";
//            break;
//        case ORKQuestionTypeTimeInterval:
//            serializerClassName = @"OMHSerializerTimeIntervalQuestion";
//            break;
//        case ORKQuestionTypeHeight:
//            serializerClassName = @"OMHSerializerHeightQuestion";
//            break;
//        case ORKQuestionTypeLocation:
//            serializerClassName = @"OMHSerializerLocationQuestion";
//            break;
        default:
            return nil;
    }
    
    Class serializerClass = NSClassFromString(serializerClassName);
    // subclass verifies it supports sample's values
    if (![serializerClass canSerialize:sample error:error]) {
        return nil;
    }
    // instantiate a serializer
    OMHSerializerQuestion* serializer = [[serializerClass alloc] initWithResult:sample];
    serializer.consent = self.consent;
    return [serializer data];
}

+ (BOOL)canSerialize:(ORKQuestionResult*)sample error:(NSError**)error {
    return YES;
}
@end

@interface OMHSerializerTextQuestion : OMHSerializerQuestion
@end

@implementation OMHSerializerTextQuestion

- (id)bodyData {
    return @{
             @"answer": ((ORKTextQuestionResult*)self.result).textAnswer
             };
}
- (NSString*)schemaName {
    return @"text-answer";
}
- (NSString*)schemaVersion {
    return @"1.0";
}
- (NSString*)schemaNamespace {
    return @"ork";
}

@end

