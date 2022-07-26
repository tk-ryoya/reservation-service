class Calendar
  include ActiveModel::Model

  def initialize
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = ENV["APPLICATION_NAME"]
    @service.authorization = authorize
    @calendar_id = ENV["CALENDAR_ID"]
  end

  def authorize
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(ENV["CLIENT_SECRET_PATH"]),
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR
    )
    authorizer.fetch_access_token!
    authorizer
  end

  def set_event(summary, description, start_time, end_time)
    event = Google::Apis::CalendarV3::Event.new(
      summary:,
      description:,
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_time.iso8601),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: end_time.iso8601)
    )
    @service.insert_event(@calendar_id, event)
  end

  def read
    now = Date.current
    next_month = now.next_month
    @service.list_events(
      @calendar_id,
      single_events: true,
      order_by: "startTime",
      time_min: Time.new(now.year, now.month, now.day).iso8601,
      time_max: Time.new(next_month.year, next_month.month, next_month.day).iso8601
    )
  end

  def delete(event_id)
    @service.delete_event(
      @calendar_id,
      event_id
    )
  end

  def closed_days
    items = read.items
    rest = items.map { |item| item.start.date if item.summary == '休診日(臨時)' }
    rest.compact
  end

  def closed_days_pm
    items = read.items
    rest = items.map { |item| item.start.date if item.summary == '午後休診(臨時)' }
    rest.compact
  end

  def match_reservations(reservation)
    items = read.items
    match_id = items.map { |item| item.id if item.description.to_s.include?("「#{reservation.id}」") }
    match_id.compact
  end

  def self.closed_days?(day)
    cal = Calendar.new
    rest = cal.closed_days
    rest.include?(day)
  end
end
