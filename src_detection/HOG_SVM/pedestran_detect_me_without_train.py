# *_*coding:utf-8 *_*
# 参考资料：https://blog.csdn.net/qq_33662995/article/details/79356939
#
# author: 许鸿斌

import os
import sys
import cv2
import logging
import numpy as np
import pandas as pd

def logger_init():
    '''
    自定义python的日志信息打印配置
    :return logger: 日志信息打印模块
    '''

    # 获取logger实例，如果参数为空则返回root logger
    logger = logging.getLogger("PedestranDetect")

    # 指定logger输出格式
    formatter = logging.Formatter('%(asctime)s %(levelname)-8s: %(message)s')

    # 文件日志
    # file_handler = logging.FileHandler("test.log")
    # file_handler.setFormatter(formatter)  # 可以通过setFormatter指定输出格式

    # 控制台日志
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.formatter = formatter  # 也可以直接给formatter赋值

    # 为logger添加的日志处理器
    # logger.addHandler(file_handler)
    logger.addHandler(console_handler)

    # 指定日志的最低输出级别，默认为WARN级别
    logger.setLevel(logging.INFO)

    return logger

def test_hog_detect(logger):
    '''
    导入测试集，测试结果
    :param test: 测试数据集
    :param svm_detector: 用于HOGDescriptor的SVM检测器
    :param logger: 日志信息打印模块
    :return: 无
    '''
    hog = cv2.HOGDescriptor()
    # opencv自带的训练好了的分类器
    hog.setSVMDetector(cv2.HOGDescriptor_getDefaultPeopleDetector())
    pwd = os.getcwd()
    DATA_PATH = 'F:/mot/obj_det/mAP/input/detection-results/' 
    brenchmark = ['ADL-Rundle-6', 'ADL-Rundle-8', 'ETH-Bahnhof', 'ETH-Pedcross2', 'ETH-Sunnyday', 
        'KITTI-13', 'KITTI-17', 'PETS09-S2L1', 'TUD-Campus', 'TUD-Stadtmitte', 'Venice-2']
    # cv2.namedWindow('Detect')
    for seq_name in brenchmark:
        test_dir = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/img1/' % seq_name
        save_path = DATA_PATH + '%s-%06d.txt'
        idx = 1
        test = os.listdir(test_dir)
        for f in test:
            file_path = os.path.join(test_dir, f)
            logger.info('Processing {}'.format(file_path))
            img = cv2.imread(file_path)
            rects, scores = hog.detectMultiScale(img, winStride=(8,8), padding=(8,8), scale=1.2)
            dets = []
            for (x,y,w,h), s in zip(rects, scores):
                s = float(s[0])
                # if s > 1:
                #     s = 2 - s
                # if s < 0.6:
                #     continue
                dets.append(['Person', s, x, y, x+w, y+h])
            dets = pd.DataFrame(dets)
            dets.to_csv(save_path % (seq_name, idx), sep=' ', index=False, header=False)

            # for (x,y,w,h), (s) in zip(rects, scores):
            #     cv2.putText(img, '#%.03f' % s,  (x,y), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 3)
            #     cv2.rectangle(img, (x,y), (x+w,y+h), (0,255,0), 3)

            # cv2.putText(img, '#%03d' % idx, (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1.2, (255, 0, 0), 3)
            # cv2.imshow('Detect', cv2.resize(img, (int(img.shape[:2][1]*0.5), int(img.shape[:2][0]*0.5))))
            # c = cv2.waitKey(1) & 0xff
            # if c == 27:
            #     break
            idx = idx + 1
            # if True:
            #     cv2.imwrite('imgs/TUD-Stadtmitte/'+ f, img);
    # cv2.destroyAllWindows()


if __name__ == '__main__': 
    logger = logger_init()
    test_hog_detect(logger)

