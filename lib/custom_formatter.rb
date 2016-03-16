class CustomFormatter < Logger::Formatter
    def call(severity, datetime, prognm, message)
        "[#{datetime.strftime("%Y-%m-%d %H:%M:%S")}] #{severity.ljust(5)}: #{message}\n"
    end

=begin
    Timestamp Format values
        %Y - Year with century
        %m - Month of the year, zero-padded
        %d - Day of the month, zero-padded
        %H - Hour of the day, 24-hour clock, zero-padded
        %M - Minute of the hour
        %S - Second of the minute
=end
end
