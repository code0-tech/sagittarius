# frozen_string_literal: true

module TracksOutages
  extend ActiveSupport::Concern

  include Sagittarius::Database::Transactional

  UPTIME_HISTORY_DAYS = 14

  # Updates the status/heartbeat and opens or closes an outage window as needed.
  def record_status!(status:, heartbeat: nil, at: Time.zone.now)
    transactional do
      self.status = status
      self.last_heartbeat = heartbeat if heartbeat

      if running?
        close_outage!(at) if current_outage_started_at.present?
      elsif current_outage_started_at.blank?
        open_outage!(at)
      end

      save!
    end
  end

  # Finalizes the portion of an ongoing outage that happened on a previous day into that
  # day's row, then re-anchors the open outage at today's midnight.
  def roll_outage_to_today!(at: Time.zone.now)
    return if current_outage_started_at.blank?
    return if current_outage_started_at.to_date == at.to_date

    transactional do
      midnight = at.beginning_of_day
      accumulate_outage!(current_outage_started_at, midnight)
      update!(current_outage_started_at: midnight)
    end
  end

  # Returns an array of UPTIME_HISTORY_DAYS uptime percentages, index 0 = today.
  def uptime_percentages(days: UPTIME_HISTORY_DAYS)
    today = Time.zone.today
    by_date = daily_uptimes.where(date: (today - (days - 1))..today).index_by(&:date)

    (0...days).map do |offset|
      date = today - offset
      daily = by_date[date]

      if date == today && current_outage_started_at.present?
        live_uptime_percentage(daily)
      elsif daily
        daily.uptime_percentage.to_f
      else
        100.0
      end
    end
  end

  private

  def open_outage!(at)
    self.current_outage_started_at = at
  end

  def close_outage!(at)
    accumulate_outage!(current_outage_started_at, at)
    self.current_outage_started_at = nil
  end

  def accumulate_outage!(from, to)
    return if to <= from

    cursor = from
    while cursor < to
      next_midnight = cursor.beginning_of_day + 1.day
      segment_end = [next_midnight, to].min
      add_outage_seconds(cursor.to_date, (segment_end - cursor).to_i)
      cursor = segment_end
    end
  end

  def add_outage_seconds(date, seconds)
    return if seconds <= 0

    daily = daily_uptimes.find_or_initialize_by(date: date)
    daily.outage_seconds += seconds
    daily.uptime_percentage = compute_uptime_percentage(date, daily.outage_seconds)
    daily.save!
  end

  def compute_uptime_percentage(date, outage_seconds)
    elapsed = date == Time.zone.today ? (Time.zone.now - Time.zone.now.beginning_of_day) : 1.day.to_i
    elapsed = 1 if elapsed <= 0

    (100.0 * (1 - (outage_seconds.to_f / elapsed))).clamp(0, 100).round(2)
  end

  def live_uptime_percentage(daily)
    now = Time.zone.now
    midnight = now.beginning_of_day
    elapsed = now - midnight
    elapsed = 1 if elapsed <= 0

    outage_so_far = (daily&.outage_seconds || 0) + (now - [current_outage_started_at, midnight].max)
    (100.0 * (1 - (outage_so_far / elapsed))).clamp(0, 100).round(2)
  end
end
