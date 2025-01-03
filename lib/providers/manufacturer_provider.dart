import 'package:flutter/material.dart';
import '../models/manufacturer.dart';
import '../services/manufacturer_service.dart';

class ManufacturerProvider with ChangeNotifier {
  List<Manufacturer> _manufacturers = [];
  bool _isLoading = false;

  List<Manufacturer> get manufacturers => _manufacturers;
  bool get isLoading => _isLoading;

  // Lấy tất cả nhà sản xuất
  Future<void> fetchAllManufacturers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _manufacturers = await ManufacturerService.getAllManufacturers();
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tạo nhà sản xuất mới
  Future<void> addManufacturer(Manufacturer manufacturer) async {
    _isLoading = true;
    notifyListeners();

    try {
      Manufacturer newManufacturer = await ManufacturerService.createManufacturer(manufacturer);
      _manufacturers.add(newManufacturer);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cập nhật nhà sản xuất
  Future<void> updateManufacturer(Manufacturer manufacturer) async {
    _isLoading = true;
    notifyListeners();

    try {
      Manufacturer updatedManufacturer = await ManufacturerService.updateManufacturer(manufacturer);
      int index = _manufacturers.indexWhere((m) => m.id == updatedManufacturer.id);
      if (index != -1) {
        _manufacturers[index] = updatedManufacturer;
      }
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa nhà sản xuất
  Future<void> deleteManufacturer(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ManufacturerService.deleteManufacturer(id);
      _manufacturers.removeWhere((m) => m.id == id);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}