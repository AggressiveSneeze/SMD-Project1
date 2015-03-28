#Solution to project1 for SWEN30006, SEM 1 2015, University of Melbourne
# Author: James Adams, Student no: 572541

#everything to 2.d.p
# 
require 'csv'
require 'matrix'
require 'linefit'
$failure='failed'

#could do all this + driver stuff outside function, turn this into a class
file_name= ARGV[0]
regression_type =ARGV[1]
lines = CSV.read(file_name)
x_array=[]
y_array=[]
#throw away line 1 for now (time, datapoint,units)
lines.shift
#accessible now as 2d array because ignoring units column for now
#store the x and y data. 
lines.each {|line|
	x_array << line[0].to_i
	y_array << line[1].to_i
}

#Performs exponential regression on the given set of x,y co-ordinates.
#Returns the coefficients of the regression of the form A*e^(B*x), 
#i.e returns a and b. If there is a domain error (log of negative number),
#error will be caught and a failure message will be sent to the driving
#block of code which will handle the graceful exit. Coefficients calculated
#using the formulas from this link: 
#http://mathworld.wolfram.com/LeastSquaresFittingExponential.html
def exp_regress x_array, y_array	
	#storage for the sums (according to the link)
	sum_1=0
	sum_2=0
	sum_3=0
	sum_4=0
	sum_5=0
	
	begin
		#Merge the two data points
		co_ords=x_array.zip(y_array)
		#calculate the sums
		co_ords.each { |x,y|
			sum_1+=(x**2)*y
			sum_2+=y*Math.log(y)
			sum_3+=x*y
			sum_4+=x*y*Math.log(y)
			sum_5+=y
		}
		#initialise the coefficient array to be returned
		results=[]
		#calculate and store the coefficients
		results[0]=(sum_1*sum_2-sum_3*sum_4)/(sum_5*sum_1-(sum_3)**2)
		results[1]=(sum_5*sum_4-sum_3*sum_2)/(sum_5*sum_1-(sum_3)**2)
		return results
	rescue Math::DomainError
		#initialise the return array, and place a failure signal in the first element.
		results=[]
		results[0]=$failure
		return results
	end
end

#polynomial regression method from the project spec
def poly_regress x_array, y_array, degree
	x_data = x_array.map { |x_i| (0..degree).map { |pow| (x_i**pow).to_f } }
	mx = Matrix[*x_data]
	my = Matrix.column_vector(y_array)
	return coefficients = ((mx.t * mx).inv * mx.t * my).transpose.to_a[0]
end

#Function to calculate variance. Takes as parameters a set of co-ordinates,
#as well as a regression function. Returns the avg variance between the actual y
#co-ordinate and the value of the regression function at a particular x value.

def avg_var(x_array,y_array,&function) 
	total=0
	co_ords=x_array.zip(y_array)
	co_ords.each {|x,y|
		total+=(y-function.call(x)).abs
	}
	return total/x_array.count
end


#Body logic/driver
case regression_type
when 'linear'
	#initialise LineFit object, and set the data correctly
	lineFit= LineFit.new
	lineFit.setData(x_array,y_array)
	#print the calculated regression line according to the spec
	puts "#{lineFit.coefficients[1].round(2)}x + #{lineFit.coefficients[0].round(2)}"
	#calculate and print the average variance from across all the pairs of co-ordinates
	var=avg_var(x_array,y_array) {|x| lineFit.coefficients[1]*x+lineFit.coefficients[0]}
	puts "Average Variance: #{var}"

when 'polynomial'
	for x in 1..10
		puts "Degree #{x}:"
		coefficients=poly_regress(x_array,y_array,x)
		for y in 0..x-1
			print "#{coefficients[y]}*x^#{x-y}"
			if coefficients[y+1]>=0
			    print "+"
			end
		end
		print"#{coefficients[x]} \n"
		#coefficients.reverse_each { |x| puts x.round(2)}
	end
#logarithmic, returns a math domain error if x is negative of course.TODO: handle
#uses ln not log base 10. good.
when 'logarithmic'
	log_x_array = x_array.map {|x| Math.log(x)}
	logFit=LineFit.new
	logFit.setData(log_x_array,y_array)
	puts "#{logFit.coefficients[1].round(2)}*ln(x) + #{logFit.coefficients[0].round(2)}"
	var=avg_var(x_array,y_array) {|x| logFit.coefficients[1].round(2)*Math.log(x) +
										logFit.coefficients[0].round(2)}
	puts "Average Variance: #{var}"									


when 'exponential'
	results=exp_regress(x_array,y_array)
	if (results[0]=$failure) 
		abort("Cannot perform exponential regression on this data.")
	end
	puts"#{Math.exp(results[0]).round(2)}e^#{results[1].round(2)}x"
	var=avg_var(x_array,y_array) {|x| Math.exp(results[0]).round(2)*
										Math.exp(results[1].round(2))}
	puts "Average Variance: #{var}"
else
	puts "error, try again"
end








#Compare with linefit now...yup work out to be the same as the above regress formula








#ToDO: Regression fit analysis



