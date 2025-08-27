// import 'package:device_calendar/device_calendar.dart'; // Temporarily disabled
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class CalendarService {
  CalendarService._internal();
  static final CalendarService _instance = CalendarService._internal();
  factory CalendarService() => _instance;

  // final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin(); // Temporarily disabled
  bool _timezoneInitialized = false;

  void _ensureTimezoneInitialized() {
    if (_timezoneInitialized) return;
    tzdata.initializeTimeZones();
    // Use the local timezone
    final locationName = DateTime.now().timeZoneName;
    // Fallback to UTC if unknown
    final location = tz.getLocation(tz.timeZoneDatabase.locations.containsKey(locationName)
        ? locationName
        : 'UTC');
    tz.setLocalLocation(location);
    _timezoneInitialized = true;
  }

  Future<bool> _requestPermissionsIfNeeded() async {
    // Temporarily disabled - return false to indicate no permissions
    return false;
  }

  Future<String?> _getDefaultCalendarId() async {
    // Temporarily disabled - return null
    return null;
  }

  Future<bool> addAssignmentToCalendar({
    required String title,
    String? description,
    required DateTime start,
    DateTime? end,
    Duration reminderOffset = const Duration(hours: 2),
  }) async {
    _ensureTimezoneInitialized();
    
    // Temporarily disabled calendar functionality
    // Show user-friendly message instead of failing silently
    print('Calendar functionality temporarily disabled - would add: $title on ${start.toString()}');
    
    // Return false to indicate failure, but with a user-friendly message
    return false;
  }
}


