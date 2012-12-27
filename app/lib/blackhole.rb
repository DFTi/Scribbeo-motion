# Sucks up all messages sent to it.
module Blackhole
  module_function
  def method_missing(meth, *args, &block) ; self ; end
end