require "easycsv/data"
require "easycsv/double_quote_wrapper"
require "easycsv/comma_separator"

module EasyCSV
  class Builder
    attr_accessor :wrapper, :separator, :data, :csv_string, :writers
    def self.build(&block)
      builder = new
      builder.instance_eval(&block)
      builder.build
    end

    def initialize
      @data = Data.new
      @wrapper = DoubleQuoteWrapper
      @separator = CommaSeparator
      @writers = WriterSet.new
    end

    def build
      generate_csv_string
      @writers.write(csv_string)
      return csv_string
    end

    def set_column_separator(separator)
      @separator = separator
    end

    def write_to_file(path)
      @writers << FileWriter.new(path)
    end

    def method_missing(m, *args, &block)
      @data.send(m, *args, &block)
    end

    private

    def generate_csv_string
      @csv_string = header_row + data_rows
    end

    def header_row
      separate( wrap(@data.headers) ) + "\n"
    end

    def data_rows
      @data.rows.map{|r| build_row(r)}.join "\n"
    end

    def build_row(r)
      row = @data.calls.map{|c| r.send(c)}
      separate( wrap(row) )
    end

    def wrap(row)
      @wrapper.new(row).wrap
    end

    def separate(row)
      @separator.new(row).separate
    end

    class WriterSet < Array
      def write(csv_string)
        self.each {|writer| writer.write(csv_string) }
      end
    end

    class FileWriter
      def initialize(path)
        @path = path
      end
      def write(csv_string)
        File.open(@path, "w") do |f|
          f.write csv_string
        end
      end
    end

  end
end
