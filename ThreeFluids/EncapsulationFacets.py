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

def gettingFacets(filename,CASE):
    print('Getting facets values for %d' % CASE)
    exe = ["./getFacet", filename, str(CASE)]
    p = sp.Popen(exe, stdout=sp.PIPE, stderr=sp.PIPE)
    stdout, stderr = p.communicate()
    temp1 = stderr.decode("utf-8")
    temp2 = temp1.split("\n")
    Xtemp = []
    Ytemp = []
    for n1 in range(len(temp2)):
        temp3 = temp2[n1].split(" ")
        if temp3 == ['']:
            pass
        else:
            Xtemp.append(float(temp3[0]))
            Ytemp.append(float(temp3[1]))
    X = np.asarray(Xtemp)
    Y = np.asarray(Ytemp)
    print('Got facets values for %d' % CASE)
    return X, Y
# ----------------------------------------------------------------------------------------------------------------------


nGFS = 31

folder = 'Facets'  # output folder
if not os.path.isdir(folder):
    os.makedirs(folder)

xmin = -0.5
xmax = 0.5
ymin = 0.0
ymax = 1

for ti in range(nGFS):
    t = 0.1 * ti
    place = "intermediate/snapshot-%5.4f" % t
    name = "%s/%4.4d.png" %(folder, ti)
    if not os.path.exists(place):
        print("File not found!")
    else:
        Xf1, Yf1 = gettingFacets(place,1)
        Xf2, Yf2 = gettingFacets(place,2)
        Xf3, Yf3 = gettingFacets(place,3)

        fig, ax = plt.subplots()
        fig.set_size_inches(19.20, 10.80)
        rc('axes', linewidth=2)
        plt.xticks(fontsize=20)
        plt.yticks(fontsize=20)

        ax.plot([-xmax, xmax],[0, 0],'--',color='silver')
        for i in range(0,len(Xf1),2):
            ax.plot([Xf1[i], Xf1[i+1]],[Yf1[i], Yf1[i+1]],'-',color='blue',linewidth=3)
        for i in range(0,len(Xf2),2):
            ax.plot([Xf2[i], Xf2[i+1]],[Yf2[i], Yf2[i+1]],'-',color='red',linewidth=3)
        for i in range(0,len(Xf3),2):
            ax.plot([Xf3[i], Xf3[i+1]],[Yf3[i], Yf3[i+1]],'-',color='green',linewidth=3)

        ax.set_xlabel(r'$X/D$', fontsize=30)
        ax.set_ylabel(r'$Y/D$', fontsize=30)
        ax.set_aspect('equal')
        ax.set_xlim(xmin, xmax)
        ax.set_ylim(ymin,ymax)
        ax.set_title('t = %5.4f' % t, fontsize=30)
        # plt.show()
        plt.savefig(name)
        plt.close()

        print(("Done %d of %d" % (ti+1, nGFS)))
