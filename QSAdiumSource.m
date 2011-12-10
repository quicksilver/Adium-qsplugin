//
//  QSAdiumSource.m
//  QSAdium
//
//  Created by Rob McBroom on 2011/12/9.
//

#import "QSAdiumSource.h"
#import <QSCore/QSObject.h>

@implementation QSAdiumSource

- (id)init {
    self = [super init];
    if (self) {
        Adium = [[SBApplication applicationWithBundleIdentifier:@"com.adiumX.adiumX"] retain];
    }
    return self;
}

- (void)dealloc {
    [Adium release];
    [super dealloc];
}

- (BOOL)indexIsValidFromDate:(NSDate *)indexDate forEntry:(NSDictionary *)theEntry
{
	return NO;
}

- (NSImage *)iconForEntry:(NSDictionary *)dict
{
	return nil;
}

// Return a unique identifier for an object (if you haven't assigned one before)
//- (NSString *)identifierForObject:(id <QSObject>)object
//{
//	return nil;
//}

- (NSArray *) objectsForEntry:(NSDictionary *)theEntry
{
	NSMutableArray *objects=[NSMutableArray arrayWithCapacity:1];
	QSObject *newObject;
	
	newObject=[QSObject objectWithName:@"TestObject"];
	[newObject setObject:@"" forType:QSAdiumType];
	[newObject setPrimaryType:QSAdiumType];
	[objects addObject:newObject];
	
	return objects;
}

// Object Handler Methods

/*
- (void)setQuickIconForObject:(QSObject *)object
{
	[object setIcon:nil]; // An icon that is either already in memory or easy to load
}

- (BOOL)loadIconForObject:(QSObject *)object
{
	return NO;
	id data=[object objectForType:kQSAdiumType];
	[object setIcon:nil];
	return YES;
}
*/
@end
