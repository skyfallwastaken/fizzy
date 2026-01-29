module TimeTrackingHelper
  def format_duration(total_seconds)
    return "0s" if total_seconds.nil? || total_seconds.zero?

    hours = total_seconds / 3600
    minutes = (total_seconds % 3600) / 60
    seconds = total_seconds % 60

    parts = []
    parts << "#{hours}h" if hours > 0
    parts << "#{minutes}m" if minutes > 0 || hours > 0
    parts << "#{seconds}s" if hours == 0

    parts.join(" ")
  end

  def format_duration_long(total_seconds)
    return "0 seconds" if total_seconds.nil? || total_seconds.zero?

    hours = total_seconds / 3600
    minutes = (total_seconds % 3600) / 60
    seconds = total_seconds % 60

    parts = []
    parts << pluralize(hours, "hour") if hours > 0
    parts << pluralize(minutes, "minute") if minutes > 0
    parts << pluralize(seconds, "second") if seconds > 0 && hours == 0

    parts.join(" ").presence || "0 seconds"
  end
end
