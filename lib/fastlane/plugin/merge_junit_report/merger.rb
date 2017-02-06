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
				
					baseline
				end

			end
		end
	end
end
