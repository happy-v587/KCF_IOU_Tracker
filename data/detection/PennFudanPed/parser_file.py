#!/usr/bin/env python
# -*- coding: utf-8 -*-
 
import os
import re
import cv2
import numpy as np

pngpath='./PNGImages/'
oritxt='./Annotation/'
newtxt='./data/'
savepath='./SingleObject/'
savepath2='./Bbox/'
 
txtfiles = os.listdir(oritxt)
matrixs  = []
index = 1
for txtpath in txtfiles:
    img = cv2.imread(pngpath + txtpath[:-4] + ".png");
    f1 = open(oritxt + txtpath, 'r')
    for line in f1.readlines():
        if re.findall('Xmin',line):
            pt = [int(x) for x in re.findall(r"\d+",line)]
            matrixs.append(pt)        
            cv2.rectangle(img, (pt[1], pt[2]), (pt[3], pt[4]), (0, 255, 0), 2)
            tmp = img[pt[2]:pt[4], pt[1]:pt[3]]
            cv2.imwrite(savepath2 + txtpath[:-4] + ".png", img)
            index = index + 1
    f1.close()

data = [line[1:5] for line in matrixs]
np.savetxt('data', data, fmt="%d,%d,%d,%d")