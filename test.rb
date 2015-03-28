$regression = 2*x^2 + x
# a=Proc.new { |x| puts $function}
# [5,1,3].each(&a)
# # def yield_test(function) 
# # 	a={|x| function }
# # 	return 

mylambda = lambda { |x| return $regression}

puts mylambda.call(5)