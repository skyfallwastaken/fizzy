module TimeTrackingHelper
  def format_duration(total_seconds)
    return "0s" if total_seconds.nil? || total_seconds.zero?

    ChronicDuration.output(total_seconds, format: :short) || "0s"
  end
end
