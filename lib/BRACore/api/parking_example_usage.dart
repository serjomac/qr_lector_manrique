// Ejemplo de uso de ApiParking
// Este archivo es solo para documentación - puedes eliminarlo después

import 'package:qr_scaner_manrique/BRACore/api/api_parking.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/parking_response.dart';

class ParkingExampleUsage {
  final ApiParking apiParking = ApiParking();
  
  Future<void> fetchParkingHistory() async {
    try {
      // Obtener historial de ingresos de parqueo
      List<ParrkingResponse> parkingEntries = await apiParking.getAllParqueoIngreso(
        placeId: "90",
        startDate: "2025-09-24 22:05:29",
        endDate: "2025-09-26 22:05:29", 
        entryType: "I", // "I" para ingresos, "S" para salidas
        doorId: "10",
      );
      
      // Procesar las respuestas
      for (var entry in parkingEntries) {
        print('Placa: ${entry.placa}');
        print('Cédula: ${entry.cedula}');
        print('Estado: ${entry.estado}');
        print('Fecha de ingreso: ${entry.fechaIngreso}');
        print('---');
      }
      
    } catch (e) {
      print('Error al obtener historial de parqueo: $e');
    }
  }
  
  Future<void> fetchParkingExits() async {
    try {
      // Obtener historial de salidas de parqueo
      List<ParrkingResponse> parkingExits = await apiParking.getAllParqueoIngreso(
        placeId: "90",
        startDate: "2025-09-24 22:05:29",
        endDate: "2025-09-26 22:05:29",
        entryType: "S", // "S" para salidas
        doorId: "10",
      );
      
      // Procesar las salidas
      for (var exit in parkingExits) {
        print('Placa: ${exit.placa}');
        print('Fecha de salida: ${exit.fechaSalida}');
        print('Tiempo total: ${exit.ingreso?.tiempoTotal}');
        print('Valor total: ${exit.ingreso?.valorTotal}');
        print('---');
      }
      
    } catch (e) {
      print('Error al obtener salidas de parqueo: $e');
    }
  }
}