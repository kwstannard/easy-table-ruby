require_relative '../../lib/easycsv/double_quote_wrapper'

describe EasyCSV::DoubleQuoteWrapper do
  describe "#wrap" do
    subject { described_class.new(row).wrap }

    context 'given an array ["entry", "yrtne"]' do
      let(:row) { ["entry", "yrtne"] }
      let(:result) { ["\"entry\"", "\"yrtne\""] }

      it { should eq(result) }
    end

    context 'given an array ["ent\"ry", "\"\"\""]' do
      let(:row) { ["ent\"ry", "\"\"\""] }
      let(:result) { ["\"ent\"\"ry\"", "\"\"\"\"\"\"\"\""] }

      it { should eq(result) }
    end

    context 'given an array [1, {a: 2}]' do
      let(:row) { [1, {a: 2}] }
      let(:result) { ["\"1\"", "\"{:a=>2}\""] }

      it { should eq(result) }
    end
  end
end
