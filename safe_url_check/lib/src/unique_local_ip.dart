import 'dart:io';

/// Returns `true` if [ip] is a unique local IPv6 address as established
/// in [rfc4193].
///
/// [rfc4193]: https://tools.ietf.org/html/rfc4193
bool isUniqueLocalIpV6(InternetAddress ip) {
  if (ip.type != InternetAddressType.IPv6) {
    return false;
  }
  // FC00::/7
  if ((ip.rawAddress[0] & (0xff << 1)) == 0xfc) {
    return true;
  }
  return false;
}
