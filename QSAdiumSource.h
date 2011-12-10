//
//  QSAdiumSource.h
//  QSAdium
//
//  Created by Rob McBroom on 2011/12/9.
//

#import <QSCore/QSObjectSource.h>

#define QSAdiumType @"QSAdiumType"

@interface QSAdiumSource : QSObjectSource
{
	AdiumApplication *Adium;
}
@end
