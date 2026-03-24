import 'package:flutter/material.dart';

class ServiceItem {
  final String id;
  final String name;
  final Color iconColor;
  final Color iconBg;
  final IconData icon;

  const ServiceItem({required this.id, required this.name, required this.iconColor, required this.iconBg, required this.icon});
}

const services = [
  ServiceItem(id: '1', name: 'Electrician', iconColor: Color(0xFFF59E0B), iconBg: Color(0xFFFFF8E1), icon: Icons.flash_on_outlined),
  ServiceItem(id: '2', name: 'Plumber', iconColor: Color(0xFF0EA5E9), iconBg: Color(0xFFE0F7FA), icon: Icons.water_drop_outlined),
  ServiceItem(id: '3', name: 'Car Wash', iconColor: Color(0xFF06B6D4), iconBg: Color(0xFFECFEFF), icon: Icons.directions_car_outlined),
  ServiceItem(id: '4', name: 'Mechanic', iconColor: Color(0xFF8B5CF6), iconBg: Color(0xFFF3EFFD), icon: Icons.build_outlined),
  ServiceItem(id: '5', name: 'Cleaner', iconColor: Color(0xFF10B981), iconBg: Color(0xFFECFDF5), icon: Icons.home_outlined),
  ServiceItem(id: '6', name: 'Painter', iconColor: Color(0xFFF97316), iconBg: Color(0xFFFFF7ED), icon: Icons.format_paint_outlined),
  ServiceItem(id: '7', name: 'Carpenter', iconColor: Color(0xFF92400E), iconBg: Color(0xFFFFFBEB), icon: Icons.handyman_outlined),
  ServiceItem(id: '8', name: 'AC Repair', iconColor: Color(0xFF0284C7), iconBg: Color(0xFFE0F2FE), icon: Icons.ac_unit_outlined),
];
