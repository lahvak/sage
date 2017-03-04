from math import fmod

def arc(center, radius, theta0 = -pi, theta1 = pi):
    """
    Returns a "complex curve" f(t) that represents an arc with center 'center', radius 'radius', 
    spanning angles between 'theta0' and 'theta1' for 0 < t < 1.
    """
    f(t) = center + radius*cos(theta0 + t*(theta1 - theta0)) + I*radius*sin(theta0 + t*(theta1 - theta0))
    return f

circle = arc

def segment(z0, z1):
    """
    Returns a "complex curve" f(t) representing a segment from 'z0' to z1' for 0 < t < 1.
    """
    f(t) = z0 + t*(z1 - z0)
    return f

def cis(theta):
    return cos(theta) + I*sin(theta)

def polar_grid(radius, circles, rays, r0 = 0, theta0 = 0, theta1 = 2*pi):
    if r0 == 0:
        rstep = radius/circles
        fr = rstep
    else:
        rstep = (radius - r0)/(circles-1)
        fr = r0

    if abs(fmod(theta1 - theta0, 2*pi)) < .01:
        astep = (theta1 - theta0)/rays
        ftheta = theta0 + astep
    else:
        astep = (theta1 - theta0)/(rays - 1)
        ftheta = theta0

    return ([arc(0, fr + rstep*n, theta0=theta0, theta1=theta1) for n in range(circles)],
            [segment(r0*cis(ftheta + n*astep),radius*cis(ftheta + n*astep)) for n in range(rays)])

def rect_grid(z0, z1, n_r, n_i):
    x0 = z0.real()
    y0 = z0.imag()
    x1 = z1.real()
    y1 = z1.imag()
    xstep = (x1 - x0)/(n_r-1)
    ystep = (y1 - y0)/(n_i-1)
    z_lt = x0 + y1*I
    z_rb = x1 + y0*I

    return ([segment(z0 + n*xstep, z_lt + n*xstep) for n in range(n_r)],
            [segment(z0 + n*ystep*I, z_rb + n*ystep*I) for n in range(n_i)])

def complex_to_point(z):
    return (z.real(), z.imag())

def complex_curve(f, a=0, b=1, **kwargs):
    return parametric_plot(complex_to_point(f(t)),(t,a,b),**kwargs)

def plot_grid(grid, f = None, a1 = 0, b1 = 1, a2 = 0, b2 = 1, color1 = "blue", color2 = "red", **kwargs):
    if f is None:
        grid1 = grid[0]
        grid2 = grid[1]
    else:
        grid1 = [compose(f,c) for c in grid[0]]
        grid2 = [compose(f,c) for c in grid[1]]

    return (sum(complex_curve(c, a=a1, b=b1, color=color1, **kwargs) for c in grid1) +
            sum(complex_curve(c, a=a2, b=b2, color=color2, **kwargs) for c in grid2))
