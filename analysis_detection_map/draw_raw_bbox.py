import os
import cv2
import numpy as np

def loadFromText(infile):
    fd = open(infile, 'r')
    readlines = fd.readlines()
    dataset = []
    for line in readlines:
        if len(line) == 0:
            continue
        temp = line.strip('/n').split(',')
        dataset.append(temp)
    return dataset

def getDets(path):
    return loadFromText(path)

def getFiles(path):
    files = os.listdir(path)
    return [path + t for t in files]

def getImgs(path):
    return getFiles(path)

def splitDetByFrame(dets):
    d = [[] for i in range(len(dets))]
    index = 0
    while index < len(dets):
        t = dets[index][0]
        if len(t) == 0:
            index = index + 1
            continue
        d[int(t)].append(dets[index])
        index = index + 1
    return d

def showImg(files):
    for file in files:
        img = cv2.imread(file)
        cv2.imshow('img', img)
        cv2.waitKey(1)

def showImgBbox(files, dets, factor = 1.0, save_dir = False):
    color = [(255,0,0),(0,255,0),(0,0,255),(255,255,0),(255,0,255),(0,255,255)]
    index = 1    
    for file in files:
        rects = dets[index-1]
        img = cv2.imread(file)
        img = cv2.resize(img, (int(img.shape[:2][1]*factor), int(img.shape[:2][0]*factor)))
        m = 0
        for rect in rects:
            if rect[6] < '0.5':
                continue
            # x, y = (int(rect[1].split('.')[0]), int(rect[2].split('.')[0]))
            # w, h = (int(rect[3].split('.')[0]), int(rect[4].split('.')[0]))
            x, y = (int(rect[2].split('.')[0])*factor, int(rect[3].split('.')[0])*factor)
            w, h = (int(rect[4].split('.')[0])*factor, int(rect[5].split('.')[0])*factor)
            cv2.rectangle(img, (int(x), int(y)), (int(x+w), int(y+h)), color[m%6], 8)
            m = m + 1 
        img[30:100,30:230] = [250,250,250]
        cv2.putText(img, '#%03d' % index, (50, 80), cv2.FONT_HERSHEY_SIMPLEX, 2, (255, 0, 0), 4)
        cv2.imshow('img', img)
        c = cv2.waitKey(1) & 0xff
        if c == 27:
            break
        if save_dir != False:
            print(save_dir + file.split('/')[-1])
            cv2.imwrite(save_dir + file.split('/')[-1], img)
        index = index + 1

def showImgBboxSVM(video, frame, factor=1.0):
    
    path_img = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/img1/%06d.jpg' % (video, frame)
    path_det = 'F:/mot/obj_det/mAP/input/detection-results_svm_all/%s-%06d.txt' % (video, frame)
    save_dir = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/img_svm/' % video
    
    if os.path.exists(save_dir) == False:
        os.makedirs(save_dir)

    fd = open(path_det, 'r')
    readlines = fd.readlines()
    rects = []
    for line in readlines:
        if len(line) == 0:
            continue
        temp = line.strip('\n').split(' ')
        rects.append(temp)

    color = [(255,0,0),(0,255,0),(0,0,255),(255,255,0),(255,0,255),(0,255,255)]
    img = cv2.imread(path_img)
    img = cv2.resize(img, (int(img.shape[:2][1]*factor), int(img.shape[:2][0]*factor)))
    m = 0
    for rect in rects:
        x1, y1 = (int(rect[2].split('.')[0])*factor, int(rect[3].split('.')[0])*factor)
        x2, y2 = (int(rect[4].split('.')[0])*factor, int(rect[5].split('.')[0])*factor)
        cv2.rectangle(img, (int(x1), int(y1)), (int(x2), int(y2)), color[m%6], 8)
        m = m + 1 
    img[30:100,30:230] = [250,250,250]
    cv2.putText(img, '#%03d' % frame, (50, 80), cv2.FONT_HERSHEY_SIMPLEX, 2, (255, 0, 0), 4)
    cv2.imshow('img', img)
    cv2.waitKey(0)

    if save_dir != False:
        print((save_dir + '%06d.jpg') % frame)
        cv2.imwrite((save_dir + '%06d.jpg') % frame, img)

def getPath(brench):
    
    path_det = 'F:/mot/obj_det/FasterRCNN/FasterRCNN/train/' + '%s.txt'
    path_det = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/det/det.txt'
    # path_det = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/gt/gt.txt'
    path_img = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/img1/'
    brenchmark = ['ADL-Rundle-6', 'ADL-Rundle-8', 'ETH-Bahnhof', 'ETH-Pedcross2', 'ETH-Sunnyday', 
            'KITTI-13', 'KITTI-17', 'PETS09-S2L1', 'TUD-Campus', 'TUD-Stadtmitte', 'Venice-2']
    save_dir = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/img_det/' % brenchmark[brench]


    # path_det = 'F:/MOT16/' + '%s.txt'
    # # path_det = 'F:/MOT16/train/%s/det/det.txt'
    # path_det = 'F:/MOT16/train/%s/gt/gt.txt'
    # path_img = 'F:/MOT16/train/%s/img1/'
    # brenchmark = ['MOT16-02', 'MOT16-04', 'MOT16-05', 'MOT16-09', 'MOT16-10', 'MOT16-11', 'MOT16-13']
    # save_dir = 'F:/MOT16/train/%s/img_gt/' % brenchmark[brench]


    if os.path.exists(save_dir) == False:
        os.makedirs(save_dir)
    return path_det % brenchmark[brench], path_img % brenchmark[brench], save_dir



if __name__ == '__main__':
    m = 0
    while m < 1:
        path_det, path_img, save_dir = getPath(m)
        data_det = getDets(path_det)
        data_img = getImgs(path_img)
        data_det = splitDetByFrame(data_det)
        showImgBbox(data_img, data_det, 0.5, save_dir)
        m = m + 1
    # showImgBboxSVM('ADL-Rundle-6', 27, 0.5)