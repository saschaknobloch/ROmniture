module ROmniture
  module Exceptions

    class OmnitureReportException < StandardError
      attr_reader :data
      def initialize(data)
        @data = data
        super
      end
    end

    class RequestInvalid < StandardError
      attr_reader :data
      def initialize(data)
        @data = data
        super
      end
    end

    class ReportNotReady < StandardError
      attr_reader :data
      def initialize(data)
        @data = data
        super
      end
    end

    class TriesExceeded < StandardError
      attr_reader :data
      def initialize(data)
        @data = data
        super
      end
    end
  end
end