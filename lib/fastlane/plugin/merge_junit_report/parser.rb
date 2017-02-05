require 'nokogiri'

module Fastlane
    module Plugin
        module MergeJunitReport
            
            class Parser
                attr_reader :file_path
                
                def initialize(file_path)
                   @file_path = file_path 
                end

                def parse
					@doc = Nokogiri::XML(File.open(@file_path))

					suites = TestSuites.new
					suites.name = @doc.root.attr('name')
					suites.tests = @doc.root.attr('tests').to_i
					suites.failures = @doc.root.attr('failures').to_i

					suites
                end
            end
        end
    end
end
