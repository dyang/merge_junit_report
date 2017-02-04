module Fastlane
  module Actions
    class MergeJunitReportAction < Action
      def self.run(params)
        UI.message("The merge_junit_report plugin is working!")
      end

      def self.description
        "Provides the ability to merge multiple junit reports into one"
      end

      def self.authors
        ["Derek Yang"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :input_files,
                                  env_name: "MERGE_JUNIT_REPORT_INPUT_FILES",
                               description: "A list of junit report files to merge from",
                                  optional: false,
                                      type: Array),
          FastlaneCore::ConfigItem.new(key: :output_file,
                                  env_name: "MERGE_JUNIT_REPORT_OUTPUT_FILE",
                               description: "The output file where all input files will be merged into",
                                  optional: true,
                                  default_value: "result.xml",
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
