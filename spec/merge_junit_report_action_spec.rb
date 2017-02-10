describe Fastlane::Actions::MergeJunitReportAction do
  default_output = 'result.xml'

  before(:each) do
    File.delete(default_output) if File.exist?(default_output)
  end

  describe '#run' do
    it 'should abort if input files not given' do
      expect do
        Fastlane::FastFile.new.parse("lane :merge do
          merge_junit_report(input_files: [])
        end").runner.execute(:merge)
      end.to raise_error 'No input files!'
    end

    it 'should abort if input file does not exist' do
      expect do
        Fastlane::FastFile.new.parse("lane :merge do
          merge_junit_report(input_files: ['file1.xml', 'file2.xml'])
        end").runner.execute(:merge)
      end.to raise_error 'File not found: file1.xml'
    end

    it 'should merge input files into default result' do
      output_file = File.absolute_path(default_output)

      Fastlane::FastFile.new.parse("lane :merge do
        merge_junit_report(input_files: ['spec/fixtures/report0.xml', 'spec/fixtures/report1.xml'])
      end").runner.execute(:merge)

      expect(File.exist?(output_file)).to be true
    end

    it 'should merge input files into designated output file' do
      output_file = File.absolute_path('output/merged.xml')
      File.delete(output_file) if File.exist?(output_file)

      Fastlane::FastFile.new.parse("lane :merge do
        merge_junit_report(input_files: ['spec/fixtures/report0.xml', 'spec/fixtures/report1.xml'], output_file: 'output/merged.xml')
      end").runner.execute(:merge)

      expect(File.exist?(output_file)).to be true
    end

    it 'should not insert xml declaration when saving to output file' do
      Fastlane::FastFile.new.parse("lane :merge do
        merge_junit_report(input_files: ['spec/fixtures/report0.xml', 'spec/fixtures/report1.xml'])
      end").runner.execute(:merge)

      File.open(default_output) { |f| expect(f.readline).not_to eql('<?xml version="1.0"?>\n') }
    end
  end
end
