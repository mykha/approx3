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
1. The program selects the functions in order and performs steps 2,3,4 thousand times for each of them.

2. A given array of points of $n$ elements, - values $(x, y)$, - the program substitutes into the equation of the function, thus obtaining $n$ equations, where the coefficients $A$, $B$, $C$ are the desired values.

3. To calculate the values of $A$, $B$, and $C$, three equations are enough, so the program:
    1. Randomly divides $n$ equations into three groups,
    2. Performs the addition of the equations in each group, thus obtaining three equations
    3. Solves the resulting system of 3 equations using the Gauss method, finds the desired values $A$, $B$, $C$.

4. Next, the program for each point substitutes the values $x$, $A$, $B$, $C$ into the equation of the function and receives the calculated value $y'$, compares it with the given value $y$ and calculates the deviation $|y(i)-y'(i)|$.
   
5. After calculating the general deviation $\sum_{i=0}^n |y(i)-y'(i)|$ 1000 times, the program selects the best result.
   
6. Performing points 2,3,4 for each function with coefficients $A$, $B$, $C$, the program calculates the general deviation 