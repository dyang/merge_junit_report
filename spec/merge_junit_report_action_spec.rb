describe Fastlane::Actions::MergeJunitReportAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The merge_junit_report plugin is working!")

      Fastlane::Actions::MergeJunitReportAction.run(nil)
    end
  end
end
