require 'nokogiri'

describe Fastlane::Plugin::MergeJunitReport::TestCase do
	xml_passed = Nokogiri::XML("<testcase classname='MyClass' name='test1'/>")			
	case_passed = Fastlane::Plugin::MergeJunitReport::TestCase.new(xml_passed.children.first)

	describe '#initialize' do
		it 'parses name and classname' do
			expect(case_passed.classname).to eql('MyClass')
			expect(case_passed.name).to eql('test1')
		end
	end

	describe '#failed?' do
		it 'parses passed status' do
			expect(case_passed.failed?).to be false
		end
	end
end
