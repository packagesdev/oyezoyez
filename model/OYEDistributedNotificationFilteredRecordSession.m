/*
 Copyright (c) 2019, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OYEDistributedNotificationFilteredRecordSession.h"

#import "NSArray+WBExtensions.h"

@interface OYEDistributedNotificationFilteredRecordSession()
{
	NSMutableArray * _filteredRecords;
}

- (BOOL)shouldFilterRecord:(OYEDistributedNotificationRecord *)inDistributedNotificationRecord;

@end

@implementation OYEDistributedNotificationFilteredRecordSession

- (instancetype)init
{
	self=[super init];
	
	if (self!=nil)
	{
		_filteredRecords=[NSMutableArray array];
	}
	
	return self;
}

#pragma mark -

- (NSArray *)records
{
	return _filteredRecords;
}

- (void)setFiltersSet:(NSSet *)inFiltersSet
{
	if (_filtersSet==inFiltersSet)
		return;
	
	_filtersSet=inFiltersSet;
	
	[_filteredRecords removeAllObjects];
	
	[self.records enumerateObjectsUsingBlock:^(OYEDistributedNotificationRecord * bRecord, NSUInteger bIndex, BOOL *bOutStop) {
		
		if ([self shouldFilterRecord:bRecord]==NO)
			[_filteredRecords addObject:bRecord];
			
	}];
	
	if ([self.delegate conformsToProtocol:@protocol(DISDistributedNotificationRecordFilteredSessionDelegate)]==YES)
	{
		[self.delegate distributedNotificationRecordFilteredSessionFilteredContentsDidChange:self];
	}
}

#pragma mark -

- (BOOL)shouldFilterRecord:(OYEDistributedNotificationRecord *)inDistributedNotificationRecord
{
	for(OYEDistributedNotificationRecordFilter * tFilter in self.filtersSet)
	{
		if ([tFilter matchesDistributedNotificationRecord:inDistributedNotificationRecord]==YES)
			return YES;
	}
	
	return NO;
}

#pragma mark -

- (void)appendRecord:(OYEDistributedNotificationRecord *)inDistributedNotificationRecord
{
	[((NSMutableArray *)self.records) addObject:inDistributedNotificationRecord];
	
	BOOL tShouldFilterRecord=[self shouldFilterRecord:inDistributedNotificationRecord];
	
	if (tShouldFilterRecord==NO)
		[_filteredRecords addObject:inDistributedNotificationRecord];
	
	if ([self.delegate conformsToProtocol:@protocol(DISDistributedNotificationRecordFilteredSessionDelegate)]==YES)
	{
		[self.delegate distributedNotificationRecordFilteredSessionContentsDidChange:self];
		
		if (tShouldFilterRecord==NO)
			[self.delegate distributedNotificationRecordFilteredSessionFilteredContentsDidChange:self];
	}
}

@end
