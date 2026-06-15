require "./library"

class Worker
  def initialize(@seed : Int32)
  end

  def fib : Int32
    fib(@seed)
  end

  private def fib(n : Int32) : Int32
    return n if n < 2

    fib(n - 1) + fib(n - 2)
  end
end

module Beta
  def self.fib(n : Int32) : Int32
    Worker.new(n).fib
  end
end

fun beta_init : LibC::Int
  PocLibrary.init
end

fun beta_fib(n : LibC::Int) : LibC::Int
  PocLibrary.protect(-1) { Beta.fib(n) }
end

fun beta_last_error : UInt8*
  PocLibrary.last_error_message
end
