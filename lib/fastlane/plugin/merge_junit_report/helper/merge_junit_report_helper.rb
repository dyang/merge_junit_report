module Fastlane
  module Helper
    class MergeJunitReportHelper
      # class methods that you define here become available in your action
      # as `Helper::MergeJunitReportHelper.your_method`
      #
      def self.show_message
        UI.message('Hello from the merge_junit_report plugin helper!')
      end
    end
  end
end
