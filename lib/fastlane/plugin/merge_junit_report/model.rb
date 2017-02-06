module Fastlane
    module Plugin
        module MergeJunitReport

            class TestSuites
				attr_reader :name
				attr_reader :tests
				attr_reader :failures
				attr_reader :testsuites

				def initialize(xml_doc)
					@name = xml_doc.root.attr('name')
					@tests = xml_doc.root.attr('tests').to_i
					@failures = xml_doc.root.attr('failures').to_i
					@testsuites = xml_doc.xpath('//testsuite').map { |element| TestSuite.new(element) }
				end
            end

            class TestSuite
				attr_reader :name
				attr_reader :tests
				attr_reader :failures
				attr_reader :testcases

				def initialize(xml_doc)
					@name = xml_doc.attr('name')
					@tests = xml_doc.attr('tests').to_i
					@failures = xml_doc.attr('failures').to_i
					@testcases = xml_doc.xpath('testcase').map { |element| TestCase.new(element) }
				end
            end

			class TestCase
				attr_reader :xml_doc
				
				def initialize(xml_doc)
					@xml_doc = xml_doc
				end

				def name
					@xml_doc.attr('name')
				end

				def classname
					@xml_doc.attr('classname')
				end

				def failed?
					@xml_doc.xpath('failure').size > 0 || 
						@xml_doc.xpath('error').size > 0 
				end
			end
        end
    end
end
