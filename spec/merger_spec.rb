require 'rexml/document'

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
      merger = Fastlane::Plugin::MergeJunitReport::Merger.new([REXML::Document.new(report0), REXML::Document.new(report1)])
      merged_report_doc = merger.merge
      expect(merged_report_doc.root.attributes['name']).to eql('FooUITests.xctest')
      expect(merged_report_doc.root.attributes['tests']).to eql('3')
      expect(merged_report_doc.root.attributes['failures']).to be nil
    end

    it 'should recalculate failures after merging testsuites' do
      merger = Fastlane::Plugin::MergeJunitReport::Merger.new([REXML::Document.new(report0), REXML::Document.new(report1)])
      merged_report_doc = merger.merge
      expect(merged_report_doc.root.attributes['failures']).to be nil
    end

    it 'should merge testcases' do
      merger = Fastlane::Plugin::MergeJunitReport::Merger.new([REXML::Document.new(report0), REXML::Document.new(report1)])
      merged_report = merger.merge
      testcases = REXML::XPath.match(merged_report, '//testsuite/testcase')

      expect(testcases.size).to eql(3)

      expect(testcases[0].attributes['classname']).to eql('FooUITests.FooUITests')
      expect(testcases[0].attributes['name']).to eql('test1')
      expect(testcases[0].attributes['time']).to eql('6.825')

      expect(testcases[1].attributes['classname']).to eql('FooUITests.FooUITests')
      expect(testcases[1].attributes['name']).to eql('test2')
      expect(testcases[1].attributes['time']).to eql('7.679')

      expect(testcases[2].attributes['classname']).to eql('FooUITests.FooUITests')
      expect(testcases[2].attributes['name']).to eql('test3')
      expect(testcases[2].attributes['time']).to eql('9.125')
      expect(testcases[2].children.size).to eql(0)
    end

    it 'should recalculate failures after merge' do
      merger = Fastlane::Plugin::MergeJunitReport::Merger.new([REXML::Document.new(report0), REXML::Document.new(report1)])
      merged_report = merger.merge
      suite = REXML::XPath.first(merged_report, '//testsuite')
      expect(suite.attributes['failures']).to be nil
    end

    it 'should yield the same report if just one report is given' do
      original = REXML::Document.new(report0)
      str_orig = ''
      original.write(str_orig, 2)

      merger = Fastlane::Plugin::MergeJunitReport::Merger.new([original])
      merged_report = merger.merge
      str_merged = ''
      merged_report.write(str_merged, 2)

      expect(str_orig).to eql(str_merged)
    end
  end
end
