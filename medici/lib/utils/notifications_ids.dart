int getQuantityNotificationId(int drugId) {
  return drugId * -2;
}

int getExpirationNotificationId(int drugId) {
  return -1 * ((drugId * 2) + 1);
}
