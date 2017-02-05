describe Fastlane::Actions::MergeJunitReportAction do
  before(:each) do
    Fastlane::Actions::MergeJunitReportAction.ui = double("FastlaneCore::UI")
  end
  
  describe '#run' do
    it 'runs like a dummy' do
      Fastlane::Actions::MergeJunitReportAction.run(:input_files => ['report1.xml', 'report2.xml'])
    end

    it 'aborts if input files not given' do
      expect(Fastlane::Actions::MergeJunitReportAction.ui).to receive(:error).with('No input files!')

      Fastlane::FastFile.new.parse("lane :merge do
        merge_junit_report(:input_files => [])  
      end").runner.execute(:merge)
    end
  end
end
