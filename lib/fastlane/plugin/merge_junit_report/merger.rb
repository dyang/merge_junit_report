module Fastlane
	module Plugin
		module MergeJunitReport
			class Merger
				def initialize(reports)
					@reports = reports
				end

				def merge
					baseline = @reports.first

					@reports.drop(1).each { |report|
						report.xpath('//testsuite').each { |suite_to_merge|
							suite_name = suite_to_merge.attr('name')
							baseline_suite = baseline.xpath("//testsuite[@name='#{suite_name}']")
							
							if baseline_suite 
								suite_to_merge.xpath('testcase').each { |case_to_merge|
									classname = case_to_merge.attr('classname')
									name = case_to_merge.attr('name')
									baseline_case = baseline_suite.at_xpath("testcase[@name='#{name}' and @classname='#{classname}']")
									if baseline_case
										baseline_case.swap(case_to_merge.to_s)
									end
								}
							end
						}
					}
				
					recalculate_failures(baseline)
					baseline
				end

				def recalculate_failures(baseline)
					total_failures = 0
					baseline.xpath('//testsuite').each { |suite|
						failures = 0
						suite.xpath('testcase').each { |testcase|
							failures += 1 if testcase.xpath('failure').size > 0
						}
						remove_or_update_failures(failures, suite)
						total_failures += failures
					}
					remove_or_update_failures(total_failures, baseline.at_xpath('/testsuites'))
				end

				def remove_or_update_failures(failures, node)
					if failures == 0
						node.remove_attribute('failures')
					else
						node['failures'] = failures.to_s
					end
				end
			end
		end
	end
end
