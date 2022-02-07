class Callee
  def call(arg1 = nil, arg2 = nil, arg3 = nil, arg4=nil)
    :foo
  end
end

r = Random.new

callees = Array.new(1000) { Callee.new }
args = Array.new(1000) { Array.new(r.rand(4)) { 1 } }

benchmark 'dispatch-mono-splat' do
  i = 0
  while i < 1000
    callees[i].call(*args[i])
    i += 1
  end
end
