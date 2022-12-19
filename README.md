# approx3
# Approximation of a given array of $n$ points $(x, y)$

## Target
The program performs an approximation of an array of points with three functions.
1. $y = A\cdot x^2+B\cdot x+C$
 
2. $y=A + \frac {B}{x} + \frac {C}{x^2}$

3. $y=\frac {x}{A\cdot x^2+B\cdot x+C}$
### Quick start
* [Ruby](https://www.ruby-lang.org/en/documentation/installation/) must be installed
* Clone this repository
  * git clone https://github.com/mykha/approx3
  * cd approx3
* Run program to approximate your data
  * ruby main.rb  \<your data file name\>
    or you can run demo 
  * ruby main.rb 2.txt
## Entrance
The source data is a text file with point coordinate values. The $x$ and $y$ values are separated by a space, each point (pair of values) is on a new line.
For best results, the number of specified points should be greater than 3.
## Exit
The result of the program is a 
+ function selected by the program from three options
and
+ values of the coefficients $A$, $B$, $C$, for which the deviation between the original $y$ and calculated $y'$ values of the function will be minimal.

## Principle of operation
The program performs an average approximation for each function, calculates the deviation and selects the result - the function and the coefficients $A$, $B$, $C$ - with the minimum general deviation

## Description of work
1. The program selects the functions in order and performs steps 2-5 thousand times for each of them.

2. A given array of points of $n$ elements, - values $(x, y)$, - the program substitutes into the equation of the function, thus obtaining $n$ equations, where the coefficients $A$, $B$, $C$ are the desired values.

3. To calculate the values of $A$, $B$, and $C$, three equations are enough, so the program:
    1. Randomly divides $n$ equations into three groups,
    2. Performs the addition of the equations in each group, thus obtaining three equations
    3. Solves the resulting system of 3 equations using the Gauss method, finds the desired values $A$, $B$, $C$.

4. Next, the program for each point substitutes the values $x$, $A$, $B$, $C$ into the equation of the function and receives the calculated value $y'$, compares it with the given value $y$ and calculates the deviation $|y(i)-y'(i)|$.
   
5. After calculating the general deviation $$\sum_{i=0}^n |y(i)-y'(i)|$$ 1000 times, the program selects the best variant of $A$, $B$, $C$.
   
6. Performing steps 2-5 for each function, the program selects the best result, - a function with coefficients $A$, $B$, $C$ with a MIN deviation from the given data.

Something like that

```
Approximation of an array of points
[{:x=>-3.0, :y=>8.5}, {:x=>-2.0, :y=>4.2}, {:x=>-1.0, :y=>0.9}, {:x= >0.0, :y=>0.01}, {:x=>1.0, :y=>1.1}, {:x=>2.0, :y=>4.2}, {:x=>3.0, :y=>10.0 }, {:x=>4.0, :y=>18.0}]
by functions:
1. Y = A*x*x + B*x + C
2. Y = A + B/x + C/(x*x)
3. Y = x/ (A*x*x + B*x + C)
function number[1] has the best result
MIN Deviation 1.7942312930906943
Equation coefficients:
A = 1.0477861998665405, B = 0.1943294466788081, C = 0.008855200533837716,
Result of approximation by points:
x=-3.0; y=8.5; y'=8.855942659296277; deviation = 0.3559426592962769
x=-2.0; y=4.2; y'=3.8113411066423835; deviation = 0.3886588933576167
x=-1.0; y=0.9; y'=0.8623119537215701; deviation = 0.03768804627842992
x=0.0; y=0.01; y'=0.008855200533837716; deviation = 0.0011447994661622843
x=1.0; y=1.1; y'=1.2509708470791865; deviation = 0.1509708470791864
x=2.0; y=4.2; y'=4.588658893357616; deviation = 0.38865889335761583
x=3.0; y=10.0; y'=10.021919339369125; deviation = 0.021919339369125268
x=4.0; y=18.0; y'=17.55075218511372; deviation = 0.44924781488628085
```
