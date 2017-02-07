require 'nokogiri'

describe Fastlane::Plugin::MergeJunitReport::Merger do
	report0 = "
		<testsuites name='FooUITests.xctest' tests='3' failures='1'>
			<testsuite name='FooUITests.FooUITests' tests='3' failures='1'>
					<testcase classname='FooUITests.FooUITests' name='test1' time='6.825'/>
					<testcase classname='FooUITests.FooUITests' name='test2' time='7.679'/>
					<testcase classname='FooUITests.FooUITests' name='test3'>
							<failure message='XCTAssertTrue failed - '>FooUITests.swift:40</failure>
					</testcase>
			</testsuite>
		</testsuites>"
	report1 = "
		<testsuites name='FooUITests.xctest' tests='1'>
			<testsuite name='FooUITests.FooUITests' tests='1'>
					<testcase classname='FooUITests.FooUITests' name='test3' time='9.125'/>
			</testsuite>
		</testsuites>"

	describe '#merge' do
		it 'should merge testsuites with name and tests' do
			merger = Fastlane::Plugin::MergeJunitReport::Merger.new([Nokogiri::XML(report0), Nokogiri::XML(report1)])
			merged_report_doc = merger.merge
			expect(merged_report_doc.root.attr('name')).to eql('FooUITests.xctest')
			expect(merged_report_doc.root.attr('tests')).to eql('3')
			expect(merged_report_doc.root.attr('failures')).to be nil
		end

		it 'should recalculate failures after merging testsuites' do
			merger = Fastlane::Plugin::MergeJunitReport::Merger.new([Nokogiri::XML(report0), Nokogiri::XML(report1)])
			merged_report_doc = merger.merge
			expect(merged_report_doc.root.attr('failures')).to be nil
		end

		it 'should merge testcases' do
			merger = Fastlane::Plugin::MergeJunitReport::Merger.new([Nokogiri::XML(report0), Nokogiri::XML(report1)])
			merged_report = merger.merge
			testcases = merged_report.xpath('//testsuite/testcase')
			
			expect(testcases.size).to eql(3)
			
			expect(testcases[0].attr('classname')).to eql('FooUITests.FooUITests')
			expect(testcases[0].attr('name')).to eql('test1')
			expect(testcases[0].attr('time')).to eql('6.825')
			
			expect(testcases[1].attr('classname')).to eql('FooUITests.FooUITests')
			expect(testcases[1].attr('name')).to eql('test2')
			expect(testcases[1].attr('time')).to eql('7.679')

			expect(testcases[2].attr('classname')).to eql('FooUITests.FooUITests')
			expect(testcases[2].attr('name')).to eql('test3')
			expect(testcases[2].attr('time')).to eql('9.125')
			expect(testcases[2].children.size).to eql(0)
		end

		it 'should recalculate failures after merge' do
			merger = Fastlane::Plugin::MergeJunitReport::Merger.new([Nokogiri::XML(report0), Nokogiri::XML(report1)])
			merged_report = merger.merge
			suite = merged_report.xpath('//testsuite').first
			expect(suite.attr('failures')).to be nil
		end
	end
end
