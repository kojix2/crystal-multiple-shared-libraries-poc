# frozen_string_literal: true

require "ffi"

ROOT = File.expand_path(__dir__)

module Alpha
  extend FFI::Library
  ffi_lib_flags :now, :local
  ffi_lib File.join(ROOT, "build", "libalpha.so")

  attach_function :alpha_init, [], :int
  attach_function :alpha_add, [:int, :int], :int
end

module Beta
  extend FFI::Library
  ffi_lib_flags :now, :local
  ffi_lib File.join(ROOT, "build", "libbeta.so")

  attach_function :beta_init, [], :int
  attach_function :beta_fib, [:int], :int
end

module Gamma
  extend FFI::Library
  ffi_lib_flags :now, :local
  ffi_lib File.join(ROOT, "build", "libgamma.so")

  attach_function :gamma_init, [], :int
  attach_function :gamma_tak, [:int, :int, :int], :int
end

puts "init: #{[Alpha.alpha_init, Beta.beta_init, Gamma.gamma_init].inspect}"
puts "alpha_add(10, 20): #{Alpha.alpha_add(10, 20)}"
puts "beta_fib(10): #{Beta.beta_fib(10)}"
puts "gamma_tak(12, 6, 0): #{Gamma.gamma_tak(12, 6, 0)}"

raise "alpha failed" unless Alpha.alpha_add(10, 20) == 32
raise "beta failed" unless Beta.beta_fib(10) == 55
raise "gamma failed" unless Gamma.gamma_tak(12, 6, 0) == 1

puts "ruby-ffi multiple-load OK"
