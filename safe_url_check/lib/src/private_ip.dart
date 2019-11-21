import 'dart:io';

/// Returns `true` if [ip] is a private IPv4 address as specified in [rfc1918].
///
/// [rfc1918]: https://tools.ietf.org/html/rfc1918
bool isPrivateIpV4(InternetAddress ip) {
  if (ip.type != InternetAddressType.IPv4) {
    return false;
  }
  // Private IP ranges from: https://tools.ietf.org/html/rfc1918
  // 10.0.0.0        -   10.255.255.255
  if (ip.rawAddress[0] == 10) {
    return true;
  }
  // 172.16.0.0      -   172.31.255.255
  if (ip.rawAddress[0] == 172 &&
      ip.rawAddress[1] >= 16 &&
      ip.rawAddress[1] <= 31) {
    return true;
  }
  // 192.168.0.0     -   192.168.255.255
  if (ip.rawAddress[0] == 192 && ip.rawAddress[1] == 168) {
    return true;
  }
  return false;
}
