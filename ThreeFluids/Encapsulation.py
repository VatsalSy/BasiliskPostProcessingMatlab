# Author: Vatsal Sanjay
# vatsalsanjay@gmail.com
# Physics of Fluids

import numpy as np
import os
import subprocess as sp
import matplotlib.pyplot as plt
from matplotlib import rc
import matplotlib
matplotlib.rcParams['text.usetex'] = True
matplotlib.rcParams['text.latex.preamble'] = [r'\boldmath']
matplotlib.rcParams['text.latex.unicode'] = True


def gettingfield(filename,LEVEL):
    print('Getting field values')
    exe = ["./getData", filename, str(xmin), str(xmax), str(ymin), str(ymax), str(nx), str(ny)]
    p = sp.Popen(exe, stdout=sp.PIPE, stderr=sp.PIPE)
    stdout, stderr = p.communicate()
    temp1 = stderr.decode("utf-8")
    temp2 = temp1.split("\n")
    Xtemp = []
    Ytemp = []
    f1temp = []
    f2temp = []
    for n1 in range(1,len(temp2)):
        temp3 = temp2[n1].split(" ")
        if temp3 == ['']:
            pass
        else:
            Xtemp.append(float(temp3[0]))
            Ytemp.append(float(temp3[1]))
            f1temp.append(float(temp3[2]))
            f2temp.append(float(temp3[3]))
    X = np.asarray(Xtemp)
    Y = np.asarray(Ytemp)
    f1 = np.asarray(f1temp)
    f2 = np.asarray(f2temp)
    X.resize((nx+1, ny+1))
    Y.resize((nx+1, ny+1))
    f1.resize((nx+1, ny+1))
    f2.resize((nx+1, ny+1))
    print('Got field values')
    return X, Y, f1, f2

# ----------------------------------------------------------------------------------------------------------------------


nGFS = 51

folder = 'Tracer'  # output folder
if not os.path.isdir(folder):
    os.makedirs(folder)

LEVEL = 10
d = 1.0
Ldomain = 16*d
# These are based on the GFSview coordinates
xmin = -2*d
xmax = 2*d
ymin = 0.0
ymax = 2*d
nx = 2**(LEVEL)
ny = 2**(LEVEL)

for ti in range(nGFS):
    t = 0.1 * ti
    place = "intermediate/snapshot-%5.4f" % t
    name = "%s/%4.4d.png" %(folder, ti)
    if not os.path.exists(place):
        print("File not found!")
    else:
        X, Y, f1, f2 = gettingfield(place, LEVEL)
        Xp = Y.transpose()
        Yp = X.transpose()
        f1 = f1.transpose()
        f2 = f2.transpose()
        X = Xp
        Y = Yp

        fig, ax = plt.subplots()
        fig.set_size_inches(19.20, 10.80)
        rc('axes', linewidth=2)
        plt.xticks(fontsize=20)
        plt.yticks(fontsize=20)

        ax.plot([-xmax, xmax],[0, 0],'--',color='silver')
        ax.contour(X, Y, f1, levels=0.5, colors='blue',linewidths=3)
        ax.contour(X, Y, f2, levels=0.5, colors='red',linewidths=3)
        ax.contour(-X, Y, f1, levels=0.5, colors='blue',linewidths=3)
        ax.contour(-X, Y, f2, levels=0.5, colors='red',linewidths=3)
        ax.contourf(X, Y, f1, levels=[0.5, 1.0], colors='blue',alpha=0.70)
        ax.contourf(X, Y, f2, levels=[0.5, 1.0], colors='red',alpha=0.70)
        ax.contourf(-X, Y, f1, levels=[0.5, 1.0], colors='blue',alpha=0.70)
        ax.contourf(-X, Y, f2, levels=[0.5, 1.0], colors='red',alpha=0.70)

        ax.set_xlabel(r'$Y/D$', fontsize=30)
        ax.set_ylabel(r'$X/D$', fontsize=30)
        ax.set_aspect('equal')
        ax.set_xlim(-2, 2)
        ax.set_ylim(2,-2)
        ax.set_title('t = %5.4f' % t, fontsize=30)
        # plt.show()
        plt.savefig(name)
        plt.close()

        print(("Done %d of %d" % (ti+1, nGFS)))
