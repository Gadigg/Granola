//
//  OMHSerializerQuestion.h
//  Pods
//
//  Created by Anders Borch on 4/24/17.
//
//

#import "OMHSerializer.h"
@import ResearchKit;

@interface OMHSerializerQuestion : OMHSerializer

- (instancetype)initWithResult:(ORKQuestionResult*)result;
- (NSString*)jsonForResult:(ORKQuestionResult*)sample error:(NSError**)error;
- (NSDictionary*)dictionaryForResult:(ORKQuestionResult*)sample error:(NSError**)error;

@end

