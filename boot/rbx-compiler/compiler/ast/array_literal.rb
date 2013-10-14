class Fancy
  class AST

    class ArrayLiteral < Rubinius::ToolSet.current::TS::AST::ArrayLiteral
      attr_accessor :array
      def initialize(line, *array)
        super(line, array)
        @array = array
      end
    end

  end
end
