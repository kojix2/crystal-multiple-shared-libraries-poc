require "./library"

class Worker
  def initialize(@base : Int32)
  end

  def add(value : Int32) : Int32
    @base + value + 2
  end
end

fun alpha_init : LibC::Int
  PocLibrary.init
end

fun alpha_add(a : LibC::Int, b : LibC::Int) : LibC::Int
  PocLibrary.protect(-1) { Worker.new(a).add(b) }
end

fun alpha_last_error : UInt8*
  PocLibrary.last_error_message
end
