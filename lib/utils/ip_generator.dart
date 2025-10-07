import 'dart:io';

class IPGenerator {
  static Future<String> getIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        // Filtrar las direcciones IPv4 y que no sean de loopback
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          return addr.address;
        }
      }
    }
    return 'Dirección IP no encontrada';
  }
}
