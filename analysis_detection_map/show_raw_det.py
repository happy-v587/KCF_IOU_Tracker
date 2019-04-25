import os
import cv2

def loadFromText(infile):
    fd = open(infile, 'r')
    readlines = fd.readlines()
    dataset = []
    for line in readlines:
        temp = line.strip('\n').split(',')
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
    d = []
    index = 1
    while True:
        t = []
        for det in dets:
            if det[0] == str(index):
                t.append(det)
        if t:
            d.append(t)
            index = index + 1
        else:
            break
        
    return d

def showImg(files):
    for file in files:
        img = cv2.imread(file)
        cv2.imshow('img', img)
        cv2.waitKey(1)

def showImgBbox(files, dets, factor = 1.0, save_dir = False):
    index = 1    
    for file in files:
        rects = dets[index-1]
        if len(rects) == 0:
            continue
        
        img = cv2.imread(file)
        img[30:100,30:230] = [250,250,250]
        for rect in rects:
            x, y = (int(rect[2]), int(rect[3]))
            w, h = (int(rect[4].split('.')[0]), int(rect[5].split('.')[0]))
            cv2.rectangle(img, (x, y), (x+w, y+h), (0, 255, 0), 8)
        cv2.putText(img, '#%03d' % index, (50, 80), cv2.FONT_HERSHEY_SIMPLEX, 2, (255, 0, 0), 5)
        img = cv2.resize(img, (int(img.shape[:2][1]*factor), int(img.shape[:2][0]*factor)))
        cv2.imshow('img', img)
        c = cv2.waitKey(0) & 0xff
        if c == 27:
            break
        if save_dir != False:
            print(save_dir + file.split('/')[-1])
            # cv2.imwrite(save_dir + file.split('/')[-1], img)
        index = index + 1

def getPath(brench):
    path_base = r'F:\mot\KCF_IOU_Tracker\data\tracking\2DMOT2015\train\\'
    path_det = path_base + '%s/det/det.txt'
    path_img = path_base + '/%s/img1/'
    brenchmark = ['ADL-Rundle-6', 'ADL-Rundle-8', 'ETH-Bahnhof', 'ETH-Pedcross2', 'ETH-Sunnyday', 
            'KITTI-13', 'KITTI-17', 'PETS09-S2L1', 'TUD-Campus', 'TUD-Stadtmitte', 'Venice-2']
    save_dir = os.path.dirname(__file__) + '/imgs/%s/' % brenchmark[brench]
    if os.path.exists(save_dir) == False:
        os.makedirs(save_dir)

    return path_det % brenchmark[brench], path_img % brenchmark[brench], save_dir

if __name__ == '__main__':
    path_det, path_img, _ = getPath(8)
    data_det = getDets(path_det)
    data_img = getImgs(path_img)
    data_det = splitDetByFrame(data_det)
    showImgBbox(data_img, data_det, 1.0)
