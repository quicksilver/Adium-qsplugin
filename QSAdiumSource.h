//
//  QSAdiumSource.h
//  QSAdium
//
//  Created by Rob McBroom on 2011/12/9.
//

//#import <QSCore/QSObjectSource.h>
#import "QSAdiumDefines.h"
#import "Adium.h"

#define QSAdiumType @"QSAdiumType"

@interface QSAdiumSource : QSObjectSource
{
	AdiumApplication *Adium;
}
@end
