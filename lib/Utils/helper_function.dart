double estimateTimeToFullCharge({
  required double currentPercent,
}) {
  // Battery capacity (Wh)
  final double batteryCapacityWh = 24 * 24;

  // How much % we still need to reach 100%
  final double requiredFraction = (100 - currentPercent) / 100;

  // Effective charging power (W)
  final double effectivePowerW = 240 * 0.9;

  // Energy needed to full charge (Wh)
  final double energyNeededWh = batteryCapacityWh * requiredFraction;

  // Time in hours
  final double timeHours = energyNeededWh / effectivePowerW;

  // Convert to minutes
  final double timeMinutes = timeHours * 60;

  return timeMinutes;
}

double estimateTimeToEmpty({
  required double currentPercent,
}) {
  // Battery capacity (Wh)
  final double batteryCapacityWh = 24 * 24;

  // Available fraction of battery
  final double availableFraction = currentPercent / 100;

  // Energy left (Wh)
  final double energyLeftWh = batteryCapacityWh * availableFraction;

  // Assume constant consumption power (W)
  final double dischargePowerW = 100;

  // Time in hours
  final double timeHours = energyLeftWh / dischargePowerW;

  // Convert to minutes
  final double timeMinutes = timeHours * 60;

  return timeMinutes;
}

double calculateEnergy({
  required double currentPercent,
}) {
  // Battery capacity (Wh)
  final double batteryCapacityWh = 24 * 24;

  // Fraction of current charge
  final double chargeFraction = currentPercent / 100;

  // Actual stored energy (Wh)
  final double storedEnergyWh = batteryCapacityWh * chargeFraction;

  return storedEnergyWh;
}

/// Function to calculate current draw
double calculateCurrent({
  required double currentPercent,
}) {
  // Robot constants (you can adjust)
  double power = 30; // watts
  double voltage = 24; // volts

  // Current = Power / Voltage
  double current = power / voltage;

  // If you want to consider % usage of power:
  return current * (currentPercent / 100);
}
