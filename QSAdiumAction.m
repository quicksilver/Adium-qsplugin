//
//  QSAdiumAction.m
//  QSAdium
//
//  Created by Rob McBroom on 2011/12/9.
//

// TODO set status for individual account

#import "QSAdiumAction.h"

@implementation QSAdiumAction

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

- (QSObject *)performActionOnObject:(QSObject *)dObject
{
	return nil;
}

- (QSObject *)sendMessage:(QSObject *)dObject to:(QSObject *)iObject
{
	NSString *message = [dObject stringValue];
//	AdiumContact *contact = [iObject objectForType:kQSAdiumContactType];
//	NSPredicate *chatFilter = [NSPredicate predicateWithFormat:@"name == %@", [contact name]];
//	AdiumChat *chat = [[[Adium chats] filteredArrayUsingPredicate:chatFilter] objectAtIndex:0];
	AdiumChat *chat = [iObject objectForType:kQSAdiumChatType];
	if ([chat exists]) {
		[chat sendMessage:message withFile:nil];
	} else {
		// with apple events
//		[Adium sendEvent:'core' id:'crel' parameters:'kocl', @"chat", 'Pwct', [NSArray arrayWithObject:contact], 'Pncw', YES, 0];
//		[[[Adium chats] lastObject] sendMessage:message withFile:nil];
		
		
		// with scripting bridge
//		NSLog(@"create chat window");
//		NSDictionary *windowProps = [NSDictionary dictionaryWithObjectsAndKeys:[contact displayName], @"name", nil];
//		AdiumChatWindow *chatWindow = [[[Adium classForScriptingClass:@"chat window"] alloc] initWithProperties:windowProps];
//		NSLog(@"add window to application");
//		[[Adium chatWindows] insertObject:chatWindow atIndex:0];
//		[chatWindow moveTo:Adium];
//		NSLog(@"chat windows: %@", [[Adium chatWindows] valueForKey:@"name"]);
//		NSArray *contacts = [NSArray arrayWithObject:contact];
//		NSDictionary *props = [NSDictionary dictionaryWithObjectsAndKeys:[contact name], @"name", contacts, @"contacts", nil];
//		NSLog(@"create chat");
//		chat = [[[Adium classForScriptingClass:@"chat"] alloc] initWithProperties:props];
//		NSLog(@"add chat to window");
//		[[chatWindow chats] addObject:chat];
//		NSLog(@"add chat to window");
//		[[chatWindow chats] insertObject:chat atIndex:0];
//		NSLog(@"add contact to chat");
//		[[[[Adium chats] objectAtIndex:0] contacts] insertObject:contact atIndex:0];
//		NSLog(@"send message");
//		[chat sendMessage:message withFile:nil];
//		[chat release];
//		[chatWindow release];
	}
	return nil;
}

- (QSObject *)setStatus:(QSObject *)dObject to:(QSObject *)iObject
{
	AdiumStatus *status = [iObject objectForType:kQSAdiumStatusType];
	[Adium setGlobalStatus:status];
	return nil;
}

- (NSArray *)validIndirectObjectsForAction:(NSString *)action directObject:(QSObject *)dObject
{
	if ([action isEqualToString:@"QSAdiumSendMessageTo"]) {
//		NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:1];
//		QSObject *object;
//		// list on-line contacts
//		NSPredicate *onlineFilter = [NSPredicate predicateWithFormat:@"statusType == %i", AdiumStatusTypesAvailable];
//		NSArray *onlineContacts = [[[Adium contacts] get] filteredArrayUsingPredicate:onlineFilter];
//		for (AdiumContact *contact in onlineContacts) {
//			object = [QSObject objectWithName:[contact displayName]];
//			//[child setDetails:[contact statusMessage]];
//			[object setIcon:[contact image]];
//			[object setObject:contact forType:kQSAdiumContactType];
//			[object setPrimaryType:kQSAdiumContactType];
//			[contacts addObject:object];
//		}
//		return contacts;
		// list active chats
		NSMutableArray *chats = [NSMutableArray arrayWithCapacity:1];
		QSObject *object;
		for (AdiumChat *chat in [Adium chats]) {
			NSString *chatName = [[[chat contacts] valueForKey:@"displayName"] componentsJoinedByString:@", "];
			object = [QSObject objectWithName:chatName];
			[object setObject:chat forType:kQSAdiumChatType];
			[object setPrimaryType:kQSAdiumChatType];
			[object setIcon:[[[chat contacts] objectAtIndex:0] image]];
			[chats addObject:object];
		}
		return chats;
	} else if ([action isEqualToString:@"QSAdiumSetStatusTo"]) {
		NSMutableArray *statusObjects = [NSMutableArray arrayWithCapacity:1];
		QSObject *object;
		// list all defined statuses
		for (AdiumStatus *status in [Adium statuses]) {
			object = [QSObject objectWithName:[status title]];
			[object setObject:status forType:kQSAdiumStatusType];
			[object setPrimaryType:kQSAdiumStatusType];
			switch ([status statusType]) {
				case AdiumStatusTypesAvailable:
					[object setIcon:[QSResourceManager imageNamed:@"AdiumStatusAvailable"]];
					break;
				case AdiumStatusTypesAway:
					[object setIcon:[QSResourceManager imageNamed:@"AdiumStatusAway"]];
					break;
				case AdiumStatusTypesOffline:
					[object setIcon:[QSResourceManager imageNamed:@"AdiumStatusOffline"]];
					break;
				case AdiumStatusTypesInvisible:
					[object setIcon:[QSResourceManager imageNamed:@"AdiumStatusHidden"]];
					break;
				default:
					[object setIcon:[QSResourceManager imageNamed:@"AdiumStatusAvailable"]];
					break;
			}
			[statusObjects addObject:object];
		}
		return statusObjects;
	}
	return nil;
}

@end
