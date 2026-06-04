import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Utility functions for MIWA app
class AppUtils {
  /// Format currency
  static String formatCurrency(double amount, {String symbol = '₦'}) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '$symbol${formatter.format(amount)}';
  }

  /// Format date
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Format time
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Format date time
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }

  /// Get time ago string
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 7) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  /// Get initials from name
  static String getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Generate random color from string
  static Color colorFromString(String str) {
    final colors = [
      const Color(0xFFFF6B35), // Orange
      const Color(0xFF2ECC71), // Green
      const Color(0xFF3498DB), // Blue
      const Color(0xFFE74C3C), // Red
      const Color(0xFF9B59B6), // Purple
      const Color(0xFFF39C12), // Yellow
      const Color(0xFF1ABC9C), // Teal
      const Color(0xFFE91E63), // Pink
    ];
    final index = str.hashCode.abs() % colors.length;
    return colors[index];
  }

  /// Validate email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate phone (Nigerian format)
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^(\+234|0)[789][01]\d{8}$');
    return phoneRegex.hasMatch(phone);
  }

  /// Calculate distance between two coordinates (km)
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth's radius in km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = _sinSquared(dLat / 2) +
        _cos(lat1) * _cos(lat2) * _sinSquared(dLon / 2);
    final c = 2 * _atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static double _toRadians(double degree) => degree * (3.141592653589793 / 180);
  static double _sinSquared(double x) => sin(x) * sin(x);
  static double _cos(double degree) => cos(_toRadians(degree));
  static double _atan2(double y, double x) => atan2(y, x);

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context, {String message = 'Please wait...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF00B894),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFD63031),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Generate order number
  static String generateOrderNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(5);
    final random = (now.microsecond % 1000).toString().padLeft(3, '0');
    return 'MIWA-$timestamp$random';
  }

  /// Generate referral code
  static String generateReferralCode(String name) {
    final prefix = name.replaceAll(' ', '').substring(0, 3).toUpperCase();
    final random = DateTime.now().microsecond.toString().substring(3, 6);
    return '$prefix$random';
  }

  /// AI donation suggestion
  static String getDonationSuggestion(double amount) {
    final meals = (amount / 500).floor();
    if (meals >= 100) return '₦${amount.toStringAsFixed(0)} can feed $meals people for a week!';
    if (meals >= 20) return '₦${amount.toStringAsFixed(0)} can feed $meals families today!';
    if (meals >= 5) return '₦${amount.toStringAsFixed(0)} can provide $meals warm meals!';
    return '₦${amount.toStringAsFixed(0)} can feed $meals person today!';
  }

  /// Mask card number
  static String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 8) return cardNumber;
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }
}