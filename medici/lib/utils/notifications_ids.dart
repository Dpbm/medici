int getQuantityNotificationId(int drugId) {
  return -1 * ((drugId * 2) + 2);
}

int getExpirationNotificationId(int drugId) {
  return -1 * ((drugId * 2) + 1);
}

int getInverseQuantityNotification(int id) {
  return ((id.abs() - 2) ~/ 2);
}

int getInverseExpirationNotification(int id) {
  return ((id.abs() - 1) ~/ 2);
}
