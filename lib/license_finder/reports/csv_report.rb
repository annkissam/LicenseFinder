require 'csv'

module LicenseFinder
  class CsvReport < Report
    COMMA_SEP =  ","

    def initialize(dependencies, options)
      super
      @columns = Array(options[:columns])
    end

    def to_s
      CSV.generate(col_sep: self.class::COMMA_SEP) do |csv|
        sorted_dependencies.each do |s|
          csv << format_dependency(s)
        end
      end
    end

    private

    def format_dependency(dep)
      @columns.map do |column|
        send("format_#{column}", dep)
      end
    end

    def format_name(dep)
      dep.name
    end

    def format_version(dep)
      dep.version
    end

    def format_licenses(dep)
      dep.licenses.map(&:name).join(self.class::COMMA_SEP)
    end

    def format_approved(dep)
      dep.approved? ? "Approved" : "Not approved"
    end

    def format_summary(dep)
      dep.summary ? dep.summary.strip : ""
    end

    def format_description(dep)
      dep.description ? dep.description.strip : ""
    end
  end
end
