module EasyCSV; class DoubleQuoteWrapper; end; end

class EasyCSV::DoubleQuoteWrapper
  def initialize(row)
    @row = row
  end

  def wrap
    @row.map{|e| "\"#{escape(e.to_s)}\""}
  end

  private
  def escape(item)
    item.gsub('"', '""')
  end
end
