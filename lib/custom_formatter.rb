class CustomFormatter < Logger::Formatter
    def call(severity, datetime, prognm, message)
        "[#{datetime.utc.iso8601}] #{severity.ljust(5)}: #{message}\n"
    end
end
