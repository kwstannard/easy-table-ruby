require_relative "../../lib/casanova/builder"

describe Casanova::Builder do
  let(:builder) { described_class.new }
  describe "#column_separator" do
    subject { builder.column_separator }

    context "default" do
      it { should eq "," }
    end

    context "setting a separator 'x'" do
      before { builder.column_separator = "x" }
      it { should eq "x" }
    end
  end

  describe "#file_path" do
    subject { builder.file_path }

    context "with a path '~/csv.csv'" do
      before { builder.file_path = "~/csv.csv" }
      it { should eq "~/csv.csv" }
    end
  end

  describe "#add_column" do
    it "should add a column object" do
      builder.add_column(:method, "header name")
      builder.add_column(:method, "header name 2")
      builder.columns.count.should eq 2
    end
  end

  describe "#add_row" do
    it "should add a row object" do
      builder.add_row(double)
      builder.add_row(double)
      builder.rows.count.should eq 2
    end
  end

  describe "#add_rows" do
    it "should add everything from an array to rows" do
      builder.add_rows( [double, double] )
      builder.add_rows( [double] )
      builder.rows.count.should eq 3
    end
  end

  describe "#build" do
    let(:path) { "/tmp/test_file.csv" }
    let(:object_1) { double(foo: "Bar", herp: "Derp") }
    let(:object_2) { double(foo: "A", herp: "B") }
    let(:result) { "Foo,Herp\nBar,Derp\nA,B" }

    after { `rm #{path}` }

    context "normal mode" do
      it "should write the file" do
        builder.file_path = path
        builder.add_column(:foo, "Foo")
        builder.add_column(:herp, "Herp")
        builder.add_row(object_1)
        builder.add_row(object_2)

        builder.build

        File.read(path).should eq(result)
      end
    end

    context "block mode" do
      it "should write the file" do
        b_path = path
        b_object_1 = object_1
        b_object_2 = object_2

        described_class.build do
          set_path(b_path)
          add_column(:foo, "Foo")
          add_column(:herp, "Herp")
          add_row(b_object_1)
          add_row(b_object_2)
        end

        File.read(b_path).should eq(result)
      end
    end
  end
end
