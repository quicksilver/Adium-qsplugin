//
//  QSAdiumSource.m
//  QSAdium
//
//  Created by Rob McBroom on 2011/12/9.
//

#import "QSAdiumSource.h"

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

- (BOOL)loadChildrenForObject:(QSObject *)object
{
	if (![Adium isRunning]) {
		return NO;
	}
	NSMutableArray *children = [NSMutableArray arrayWithCapacity:1];
	QSObject *child;
	if ([[object identifier] isEqualToString:@"QSAdiumAccountBrowser"]) {
		// list all accounts
		for (AdiumAccount *account in [Adium accounts]) {
			child = [QSObject objectWithName:[account name]];
			[child setDetails:[[account service] name]];
			[child setIcon:[[account service] image]];
			[child setPrimaryType:kQSAdiumAccountType];
			[children addObject:child];
		}
	} else if ([[object identifier] isEqualToString:@"QSAdiumContactBrowser"]) {
		// list on-line contacts
		NSPredicate *onlineFilter = [NSPredicate predicateWithFormat:@"statusType == %i", AdiumStatusTypesAvailable];
		NSArray *onlineContacts = [[[Adium contacts] get] filteredArrayUsingPredicate:onlineFilter];
		for (AdiumContact *contact in onlineContacts) {
			child = [QSObject objectWithName:[contact displayName]];
			//[child setDetails:[contact statusMessage]];
			[child setIcon:[contact image]];
			[child setPrimaryType:kQSAdiumContactType];
			[children addObject:child];
		}
	} else if ([[object identifier] isEqualToString:@"QSAdiumChatBrowser"]) {
		// list active chats
		for (AdiumChat *chat in [Adium chats]) {
			child = [QSObject objectWithName:[chat name]];
			[child setObject:chat forType:kQSAdiumChatType];
			[child setPrimaryType:kQSAdiumChatType];
			[child setIcon:[QSResourceManager imageNamed:@"AdiumDefaultIcon"]];
			[children addObject:child];
		}
	} else {
		// this is Adium.app - list browser objects
		child = [QSObject makeObjectWithIdentifier:@"QSAdiumAccountBrowser"];
		[child setPrimaryType:kQSAdiumBrowserType];
		[child setName:@"Accounts"];
		[child setIcon:[QSResourceManager imageNamed:@"AdiumServicesIcon"]];
		[children addObject:child];
		child = [QSObject makeObjectWithIdentifier:@"QSAdiumContactBrowser"];
		[child setPrimaryType:kQSAdiumBrowserType];
		[child setName:@"On-line Contacts"];
		[child setIcon:[QSResourceManager imageNamed:@"AdiumContactsIcon"]];
		[children addObject:child];
		child = [QSObject makeObjectWithIdentifier:@"QSAdiumChatBrowser"];
		[child setPrimaryType:kQSAdiumBrowserType];
		[child setName:@"Active Chats"];
		[child setIcon:[QSResourceManager imageNamed:@"AdiumChatsIcon"]];
		[children addObject:child];
	}
	[object setChildren:children];
	return YES;
}

- (id)resolveProxyObject:(id)proxy
{
	if (![proxy isKindOfClass:[NSString class]]) {
		proxy = [proxy identifier];
	}
	if ([proxy isEqualToString:@"QSAdiumActiveChat"]) {
		AdiumChat *active = [[Adium activeChat] get];
		QSObject *chatProxy = [QSObject objectWithName:[active name]];
		[chatProxy setIcon:[[[active contacts] objectAtIndex:0] image]];
		[chatProxy setObject:active forType:kQSAdiumChatType];
		[chatProxy setPrimaryType:kQSAdiumChatType];
		return chatProxy;
	}
	return nil;
}

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
