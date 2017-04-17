module Fastlane
  module Plugin
    module MergeJunitReport
      # Merge several junit reports into one single report
      class Merger
        # Initializes an instance of Merger
        # @param [Array<REXML::Document>] junit reports the junit reports to merge from
        # @return [Merger]
        def initialize(reports)
          @reports = reports
        end

        # Merges reports passed in via constructor
        # @return [REXML::Document] merged junit report
        def merge
          baseline = @reports.first
          @reports.drop(1).each do |report|
            report.elements.each('//testsuite') do |suite_to_merge|
              suite_name = suite_to_merge.attributes['name']
              baseline_suite = REXML::XPath.first(baseline, "//testsuite[@name='#{suite_name}']")

              next unless baseline_suite
              suite_to_merge.elements.each('testcase') do |case_to_merge|
                classname = case_to_merge.attributes['classname']
                name = case_to_merge.attributes['name']
                baseline_case = REXML::XPath.first(baseline_suite, "testcase[@name='#{name}' and @classname='#{classname}']")
                # Replace baseline_case with case_to_merge
                if baseline_case
                  baseline_case.parent.insert_after(baseline_case, case_to_merge)
                  baseline_case.parent.delete_element(baseline_case)
                end
              end
            end
          end

          recalculate_failures(baseline)
          baseline
        end

        def recalculate_failures(baseline)
          total_failures = 0
          baseline.elements.each('//testsuite') do |suite|
            failures = 0
            suite.elements.each('testcase') { |testcase| failures += 1 unless REXML::XPath.match(testcase, 'failure').empty? }
            remove_or_update_failures(failures, suite)
            total_failures += failures
          end
          remove_or_update_failures(total_failures, REXML::XPath.first(baseline, '/testsuites'))
        end

        def remove_or_update_failures(failures, node)
          if failures.zero?
            node.delete_attribute('failures')
          else
            node.attributes['failures'] = failures.to_s
          end
        end

        private :recalculate_failures, :remove_or_update_failures
      end
    end
  end
end
