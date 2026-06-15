# Runtime helper for Crystal code compiled as a C ABI shared library.
#
# This is intentionally part of the PoC. Each library exports its own prefixed C
# ABI functions and keeps this helper internal via the export map.

module PocLibrary
  # 0 = not initialized, 1 = initializing, 2 = initialized, 3 = failed.
  @@state : Int32 = 0
  @@last_error_message : String? = nil

  def self.init : LibC::Int
    argv0 = "crystal-shared-poc".to_unsafe
    init(1, pointerof(argv0))
  end

  def self.init(argc : Int32, argv : UInt8**) : LibC::Int
    case @@state
    when 2
      return 0
    when 1
      return -2
    when 3
      return 1
    end

    @@state = 1
    clear_error

    GC.init
    Crystal.init_runtime
    Crystal.main_user_code(argc, argv)

    @@state = 2
    0
  rescue ex
    @@state = 3
    store_error(ex)
    1
  end

  def self.last_error_message : UInt8*
    if message = @@last_error_message
      message.to_unsafe
    else
      Pointer(UInt8).null
    end
  end

  def self.clear_error : Nil
    @@last_error_message = nil
  end

  def self.store_error(ex : Exception) : Nil
    @@last_error_message = String.build do |io|
      ex.inspect_with_backtrace(io)
    end
  end

  def self.protect(failure : T, &block : -> T) : T forall T
    return failure unless init == 0

    clear_error
    block.call
  rescue ex
    store_error(ex)
    failure
  end
end
