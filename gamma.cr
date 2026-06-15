require "./library"

class Worker
  def initialize(@x : Int32, @y : Int32, @z : Int32)
  end

  def tak : Int32
    tak(@x, @y, @z)
  end

  private def tak(x : Int32, y : Int32, z : Int32) : Int32
    return z unless y < x

    tak(
      tak(x - 1, y, z),
      tak(y - 1, z, x),
      tak(z - 1, x, y)
    )
  end
end

module Gamma
  def self.tak(x : Int32, y : Int32, z : Int32) : Int32
    Worker.new(x, y, z).tak
  end
end

fun gamma_init : LibC::Int
  PocLibrary.init
end

fun gamma_tak(x : LibC::Int, y : LibC::Int, z : LibC::Int) : LibC::Int
  PocLibrary.protect(-1) { Gamma.tak(x, y, z) }
end

fun gamma_last_error : UInt8*
  PocLibrary.last_error_message
end
