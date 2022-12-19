# approx3
# Approximation of a given array of points (x, y)

## Target
The program performs an approximation of an array of points with three functions.
1. $Y = A\cdot x^2+B\cdot x+C$
 
2. $Y=A + \frac {B}{x} + \frac {C}{x^2}$

3. $Y=\frac {x}{A\cdot x^2+B\cdot x+C}$
### Quick start
*Install Ruby
*Clone this repository
git clone https://github.com/mykha/approx3
cd approx3

ruby main.rb <your data file name>

or you can run demo
ruby main.rb 2.txt
## Entrance
The source data is a text file with point coordinate values. The $x$ and $Y$ values are separated by a space, each point (pair of values) is on a new line.


