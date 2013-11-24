module ActiveRecord
  module ConnectionAdapters
    # PostgreSQL-specific extensions to column definitions in a table.
    class PostgreSQLColumn < Column #:nodoc:

      # Maps PostgreSQL-specific data types to logical Rails types.
      def simplified_type(field_type)
        case field_type
          when /^numrange$/
            :string
          when /^int4range$/
            :string
          # Numeric and monetary types
          when /^(?:real|double precision)$/
            :float
          # Monetary types
          when 'money'
            :decimal
          # Character types
          when /^(?:character varying|bpchar)(?:\(\d+\))?$/
            :string
          # Binary data types
          when 'bytea'
            :binary
          # Date/time types
          when /^timestamp with(?:out)? time zone$/
            :datetime
          when 'interval'
            :string
          # Geometric types
          when /^(?:point|line|lseg|box|"?path"?|polygon|circle)$/
            :string
          # Network address types
          when /^(?:cidr|inet|macaddr)$/
            :string
          # Bit strings
          when /^bit(?: varying)?(?:\(\d+\))?$/
            :string
          # XML type
          when 'xml'
            :xml
          # tsvector type
          when 'tsvector'
            :tsvector
          # Arrays
          when /^\D+\[\]$/
            :string
          # Object identifier types
          when 'oid'
            :integer
          # UUID type
          when 'uuid'
            :string
          # Small and big integer types
          when /^(?:small|big)int$/
            :integer
          # Pass through all types that are not specific to PostgreSQL.
          else
            super
        end
      end

    end


  #
  #class PostgreSQLAdapter < AbstractAdapter
  #  module OID
  #
  #    class IntRange < Type
  #      def type_cast(value)
  #        return if value.nil?
  #
  #        ConnectionAdapters::PostgreSQLColumn.string_to_range value
  #      end
  #    end
  #
  #    register_type 'int4range', OID::IntRange.new
  #
  #  end
  #end


  end
end

class RangeSupport
  def self.string_to_range(val)
    if val =~ /\[(\d+),(\d+)\]/
      ($1.to_i .. $2.to_i)
    elsif val =~ /\[(\d+),(\d+)\)/
      ($1.to_i .. $2.to_i - 1)
    elsif val =~ /\[(\d+\.\d+),(\d+\.\d+)\]/
      ($1.to_f .. $2.to_f)
    elsif val =~ /\[(\d+\.\d+),(\d+\.\d+)\)/
      ($1.to_f .. $2.to_f - 1)
    elsif val =~ /,/
      begin
        start_time = DateTime.parse(val.split(",")[0])
        end_time = DateTime.parse(val.split(",")[1])
        (start_time .. end_time)
      rescue Exception => e
      end
    elsif val =~ /^(\d+)$/
      ($1.to_i .. $1.to_i)
    elsif val =~ /(\d+.\d+)/
      ($1.to_f .. $1.to_f)
    elsif val.kind_of?(Integer)
      (val .. val)
    end
  end

  def self.range_to_string(object)
    from = object.begin.respond_to?(:infinite?) && object.begin.infinite? ? '' : object.begin
    to   = object.end.respond_to?(:infinite?) && object.end.infinite? ? '' : object.end
    v = "[#{from},#{to}#{object.exclude_end? ? ')' : ']'}"
    puts v
    v
  end

end