#include "MPSourceParser.h"
#include "libs/cpp-base64-2.rc.08/base64.h"


/*{
        "fakeid": "MjM5NzgwNDg0MQ==",
        "nickname": "�Ͽ���ѧ",
        "alias": "nankaiuni",
        "round_head_img": "http://mmbiz.qpic.cn/mmbiz_png/lFwibdBqNNWsqBozAbXld2c2wxkewxfibFiatuaGAJsUYUhwTdtYibqsJ3wM8Zmk1JK2kvmC8XtCy7Q0CwmArZmV1Q/0?wx_fmt=png",
        "service_type": 0,
        "signature": "�ʹ����ܣ��������졣�������Ͽ���ѧ��΢�������Ͽ���ӭ��~",
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
QString MPSourceParser::getRawID(const QJsonObject& source) {
    return source["fakeid"].toString();
}
QString MPSourceParser::getAvatar(const QJsonObject& source) {
    return source["round_head_img"].toString();
}

