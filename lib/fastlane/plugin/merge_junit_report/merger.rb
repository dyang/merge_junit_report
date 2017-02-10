module Fastlane
  module Plugin
    module MergeJunitReport
      class Merger
        def initialize(reports)
          @reports = reports
        end

        def merge
          baseline = @reports.first

          @reports.drop(1).each do |report|
            report.xpath('//testsuite').each do |suite_to_merge|
              suite_name = suite_to_merge.attr('name')
              baseline_suite = baseline.xpath("//testsuite[@name='#{suite_name}']")

              next unless baseline_suite
              suite_to_merge.xpath('testcase').each do |case_to_merge|
                classname = case_to_merge.attr('classname')
                name = case_to_merge.attr('name')
                baseline_case = baseline_suite.at_xpath("testcase[@name='#{name}' and @classname='#{classname}']")
                baseline_case.swap(case_to_merge.to_xml) if baseline_case
              end
            end
          end

          recalculate_failures(baseline)
          baseline
        end

        def recalculate_failures(baseline)
          total_failures = 0
          baseline.xpath('//testsuite').each do |suite|
            failures = 0
            suite.xpath('testcase').each { |testcase| failures += 1 unless testcase.xpath('failure').empty? }
            remove_or_update_failures(failures, suite)
            total_failures += failures
          end
          remove_or_update_failures(total_failures, baseline.at_xpath('/testsuites'))
        end

        def remove_or_update_failures(failures, node)
          if failures.zero?
            node.remove_attribute('failures')
          else
            node['failures'] = failures.to_s
          end
        end

        private :recalculate_failures, :remove_or_update_failures
      end
    end
  end
end
