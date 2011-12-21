//
//  QSAdiumAction.h
//  QSAdium
//
//  Created by Rob McBroom on 2011/12/9.
//

//#import <QSCore/QSActionProvider.h>
#import "QSAdiumDefines.h"
#import "Adium.h"

#define kQSAdiumAction @"QSAdiumAction"

@interface QSAdiumAction : QSActionProvider
{
	AdiumApplication *Adium;
}
@end
