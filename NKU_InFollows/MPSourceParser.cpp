#include "MPSourceParser.h"
#include "libs/cpp-base64-2.rc.08/base64.h"


/*{
        "fakeid": "MjM5NzgwNDg0MQ==",
        "nickname": "南开大学",
        "alias": "nankaiuni",
        "round_head_img": "http://mmbiz.qpic.cn/mmbiz_png/lFwibdBqNNWsqBozAbXld2c2wxkewxfibFiatuaGAJsUYUhwTdtYibqsJ3wM8Zmk1JK2kvmC8XtCy7Q0CwmArZmV1Q/0?wx_fmt=png",
        "service_type": 0,
        "signature": "允公允能，日新月异。这里是南开大学官微，百年南开欢迎你~",
        "username": "",
        "verify_status": 2
      },
 */

QString realIDConstructor(const QString& id) {
	std::string decoded = base64_decode(id.toStdString());
	return QString::fromStdString(std::string("MP_WXS_" + decoded));
}


QString MPSourceParser::getNickname(const QJsonObject& source) {
	return source["nickname"].toString();
}
QString MPSourceParser::getDescription(const QJsonObject& source) {
	return source["signature"].toString();
}
QString MPSourceParser::getRealID(const QJsonObject& source) {
    return realIDConstructor(source["fakeid"].toString());
}

