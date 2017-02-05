describe Fastlane::Plugin::MergeJunitReport::Parser do

	file_path ='spec/fixtures/report0.xml'.freeze
	parser = Fastlane::Plugin::MergeJunitReport::Parser.new(file_path)

	describe '#initialize' do
		it 'initializes with file_path' do
			expect(parser.file_path).to eq(file_path)
		end
	end

	describe '#parse' do
		it 'produces fixtures with name and test count' do
			report = parser.parse
			expect(report).to_not be_nil
			expect(report.name).to eql('FooUITests.xctest')
			expect(report.tests).to eql(3)
			expect(report.failures).to eql(1)
		end
	end
end
