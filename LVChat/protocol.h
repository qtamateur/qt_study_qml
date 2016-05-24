#ifndef PROTOCOL_H
#define PROTOCOL_H

//所以的报文协议都在这个头文件中定义，其中以"\r\n"为协议解析的边界，英文逗号作为一个报文内字段之间的分隔符
#define SERVER_PORT   5661
#define PACKET_LINE_MARK    "\r\n"
#define DISCOVER_PACKET "discover"
#define DISCOVER_PACKET_FULL  "discover\r\n"
#define DISCOVER_REPLY_FORMAT "discover,${name},${portraitIndex}\r\n"  //发现回应报文的格式
#define DISCOVER_REPLY_MARK "discover,%1,%2\r\n"
#define TALK_REQ_PACKET_FORMAT "talking,${name},${portraitIndex}\r\n"
#define TALK_REQ_PACKET_MARK  "talking,%1,%2\r\n"
#define TALK_REQ_TOKEN      "talking"
#define TALK_REJECT_PACKET "reject"
#define TALK_REJECT_PACKET_FULL "reject\r\n"
#define TALK_ACCEPT_PACKET "accept"
#define TALK_ACCEPT_PACKET_FULL "accept\r\n"

#define MESSAGE_PACKET_MARK "message"
#define MESSAGE_PACKET_FORMAT "message,${type},${lengthOfBody},${duration},${format}\r\n${BODY DATA}"

#define PACKET_DISCOVER       1
#define PACKET_DISCOVER_REPLY 2
#define PACKET_TALK_REQ       3
#define PACKET_TALK_ACCEPT    4
#define PACKET_TALK_REJECT    5
#define PACKET_MESSAGE        6
#define PACKET_MESSAGE_TEXT   1
#define PACKET_MESSAGE_VOICE  2

#endif // PROTOCOL_H
