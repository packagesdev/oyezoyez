/*
 Copyright (c) 2019, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OYEDistributedNotificationRecord.h"

NSString * const DISDistributedNotificationRecordUUIKey=@"uuid";

NSString * const DISDistributedNotificationRecordTimeStampKey=@"timestamp";

NSString * const DISDistributedNotificationRecordDistributedNotificationKey=@"distributedNotification";

@implementation OYEDistributedNotificationRecord

- (instancetype)initWithDistributedNotification:(OYEDistributedNotification *)inDistributedNotification
{
	self=[super init];
	
	if (self!=nil)
	{
		_uuid=[[NSUUID UUID] UUIDString];
		
		_timestamp=[NSDate date];
		
		_distributedNotification=inDistributedNotification;
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
		NSString * tUUID=inRepresentation[DISDistributedNotificationRecordUUIKey];
		
		if (tUUID==nil || [tUUID isKindOfClass:[NSString class]]==NO)
			return nil;
		
		_uuid=[tUUID copy];
		
		NSDate * tTimeStamp=inRepresentation[DISDistributedNotificationRecordTimeStampKey];
		
		if (tTimeStamp!=nil && [tTimeStamp isKindOfClass:[NSDate class]]==NO)
			return nil;
		
		_timestamp=tTimeStamp;
		
		OYEDistributedNotification * tDistributedNotification=[[OYEDistributedNotification alloc] initWithRepresentation:inRepresentation[DISDistributedNotificationRecordDistributedNotificationKey]];
		
		if (tDistributedNotification==nil)
			return nil;
		
		_distributedNotification=tDistributedNotification;
	}
	
	return self;
}

- (NSDictionary *)representation
{
	NSMutableDictionary * tRepresentation=[NSMutableDictionary dictionaryWithObject:self.uuid forKey:DISDistributedNotificationRecordUUIKey];
	
	tRepresentation[DISDistributedNotificationRecordTimeStampKey]=self.timestamp;
	
	NSDictionary * tDictionary=[self.distributedNotification representation];
	
	tRepresentation[DISDistributedNotificationRecordDistributedNotificationKey]=tDictionary;
	
	return [tRepresentation copy];
}

@end
