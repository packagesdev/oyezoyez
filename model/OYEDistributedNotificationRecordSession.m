/*
 Copyright (c) 2019, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OYEDistributedNotificationRecordSession.h"

#import "NSArray+WBExtensions.h"

@interface OYEDistributedNotificationRecordSession ()
{
	NSMutableArray * _records;
}

@end

@implementation OYEDistributedNotificationRecordSession

- (instancetype)init
{
	self=[super init];
	
	if (self!=nil)
	{
		_records=[NSMutableArray array];
	}
	
	return self;
}

#pragma mark - DISRepresentable

- (instancetype)initWithRepresentation:(NSDictionary *)inRepresentation
{
	if (inRepresentation==nil || [inRepresentation isKindOfClass:[NSDictionary class]]==NO)
		return nil;
	
	self=[super init];
	
	if (self!=nil)
	{
		NSNumber * tNumber=inRepresentation[@"Version"];
		
		if (tNumber==nil || [tNumber isKindOfClass:NSNumber.class]==NO)
			return nil;
		
		NSArray * tArray=inRepresentation[@"Records"];
		
		_records=[[tArray WB_arrayByMappingObjectsUsingBlock:^id(NSDictionary *bRecordRepresentation, NSUInteger bIndex) {
			
			return [[OYEDistributedNotificationRecord alloc] initWithRepresentation:bRecordRepresentation];
			
		}] mutableCopy];
	}
	
	return self;
}

- (instancetype)initWithContentsOfURL:(NSURL *)inURL error:(NSError * __autoreleasing *)outError
{
	if (inURL==nil)
	{
		if (outError!=NULL)
			*outError=[NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
		
		return nil;
	}
	
	NSError * tError=nil;
	
	NSData * tData=[NSData dataWithContentsOfURL:inURL options:0 error:&tError];
	
	if (tData==nil)
	{
		if (outError!=NULL)
			*outError=tError;
		
		return nil;
	}
	
	NSDictionary * tRepresentation=[NSPropertyListSerialization propertyListWithData:tData
																			 options:NSPropertyListImmutable
																			  format:NULL
																			   error:&tError];
	
	if (tRepresentation==nil)
	{
		if (outError!=NULL)
			*outError=tError;
		
		return nil;
	}
	
	return [self initWithRepresentation:tRepresentation];
}

- (NSDictionary *)representation
{
	NSMutableDictionary * tRepresentation=[NSMutableDictionary dictionary];
	
	tRepresentation[@"Version"]=@(1);
	
	tRepresentation[@"Records"]=[self.records WB_arrayByMappingObjectsUsingBlock:^id(OYEDistributedNotificationRecord * bRecord, NSUInteger bIndex) {
		
		return [bRecord representation];
		
	}];
	
	return tRepresentation;
}

#pragma mark -

- (NSArray *)records
{
	return _records;
}

#pragma mark -

- (void)appendRecord:(OYEDistributedNotificationRecord *)inDistributedNotificationRecord
{
	[_records addObject:inDistributedNotificationRecord];
	
	if ([self.delegate conformsToProtocol:@protocol(OYEDistributedNotificationRecordSessionDelegate)]==YES)
		[self.delegate distributedNotificationRecordSessionContentsDidChange:self];
}

#pragma mark -

- (BOOL)writeToURL:(NSURL *)inURL atomically:(BOOL)inAtomically error:(NSError * __autoreleasing *)outError
{
	if (inURL==nil)
	{
		if (outError!=NULL)
			*outError=[NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
		
		return NO;
	}
	
	NSError * tError=nil;
	
	NSData * tData=[NSPropertyListSerialization dataWithPropertyList:[self representation] format:NSPropertyListXMLFormat_v1_0 options:0 error:&tError];
	
	if (tData==nil)
	{
		if (outError!=NULL)
			*outError=tError;
		
		return NO;
	}
	
	if ([tData writeToURL:inURL options:NSDataWritingAtomic error:&tError]==NO)
	{
		if (outError!=NULL)
			*outError=tError;
		
		return NO;
	}
	
	return YES;
}

@end
