describe Fastlane::Plugin::MergeJunitReport::Parser do

	file_path ='spec/fixtures/report0.xml'.freeze
	parser = Fastlane::Plugin::MergeJunitReport::Parser.new(file_path)

	describe '#initialize' do
		it 'initializes with file_path' do
			expect(parser.file_path).to eq(file_path)
		end
	end

	describe '#parse' do
		it 'parses suites with name and counts' do
			report = parser.parse
			expect(report).to_not be_nil
			expect(report.name).to eql('FooUITests.xctest')
			expect(report.tests).to eql(3)
			expect(report.failures).to eql(1)
		end

		it 'parses each suite with name and counts' do
			suites = parser.parse.testsuites
			expect(suites.size).to eql(1)
			expect(suites.first.name).to eql('FooUITests.FooUITests')
			expect(suites.first.tests).to eql(3)
			expect(suites.first.failures).to eql(1)
		end
		
		it 'parses test cases' do
			suite = parser.parse.testsuites.first
			testcases = suite.testcases
			expect(testcases.size).to eql(3)
		end
	end
end
