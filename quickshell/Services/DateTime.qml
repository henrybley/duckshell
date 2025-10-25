pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  property var date: new Date()
  readonly property string timeString: {
    Qt.formatDateTime(clock.date, "hh:mm")
  }
  readonly property string dateString: {
    Qt.formatDateTime(clock.date, "yyyy-MM-dd")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
