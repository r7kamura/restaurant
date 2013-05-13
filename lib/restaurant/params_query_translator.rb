class Restaurant::ParamsQueryTranslator
  def self.translate(*args)
    new(*args).translate
  end

  attr_reader :params, :resources

  def initialize(params, resources)
    @params = params
    @resources = resources
  end

  def translate
    filters.inject(resources) do |result, filter|
      filter.call(result)
    end
  end

  def filters
    where_filters + order_filters
  end

  private

  def where_filters
    where.map do |column, value|
      WhereFilter.new(column, value)
    end
  end

  def order_filters
    order.map do |column|
      OrderFilter.new(column)
    end
  end

  def where
    params[:where] || []
  end

  def order
    case params[:order]
    when String
      [params[:order]]
    else
      []
    end
  end

  class WhereFilter
    attr_reader :column, :value

    def initialize(column, value)
      @column = column
      @value = value
    end

    def call(resources)
      if value.is_a? String
        self.class.new(key => { "eq" => value }).call(*args)
      else
        sections.inject(resources) do |relation, section|
          relation.where("#{column} #{section.operator}", *section.operand)
        end
      end
    end

    private

    def sections
      value.map do |operator, operand|
        Section.new(operator, operand)
      end
    end

    class Section
      attr_reader :raw_operator, :raw_operand

      def initialize(raw_operator, raw_operand)
        @raw_operator = raw_operator
        @raw_operand = raw_operand
      end

      def operator
        case raw_operator
        when "eq"
          "= ?"
        end
      end

      def operand
        case raw_operand
        when true
          []
        else
          [raw_operand]
        end
      end
    end
  end

  class OrderFilter
    attr_reader :raw_column

    def initialize(raw_column)
      @raw_column = raw_column
    end

    def call(resources)
      resources.order("#{column} #{order}")
    end

    private

    def column
      raw_column.to_s.gsub(/^-/, "")
    end

    def order
      if desc?
        "DESC"
      else
        "ASC"
      end
    end

    def desc?
      /^-/ === raw_column.to_s
    end
  end
end
