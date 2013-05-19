module ActiveRecord
  module ConnectionAdapters
  puts "load postgres"
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