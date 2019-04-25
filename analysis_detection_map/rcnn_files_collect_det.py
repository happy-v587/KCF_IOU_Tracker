import os
import pandas as pd

# ROOT_PATH = 'F:/mot/obj_det/FasterRCNN/FasterRCNN/'
# DATA_PATH = ROOT_PATH + 'data/'
# TRAIN_PATH =ROOT_PATH + 'train/' 
DATA_PATH = 'F:/mot/obj_det/mAP/input/detection-results/' 
TRAIN_PATH = 'F:/mot/code/data/faster-rcnn/train/'

if os.path.exists(DATA_PATH) == False:
    os.makedirs(DATA_PATH)

seq_names = os.listdir(TRAIN_PATH)

for seq_name in seq_names:
    det_path = TRAIN_PATH + seq_name
    save_path = DATA_PATH + '%s-%06d.txt'
    dataset = pd.read_csv(det_path, sep=',', header=None)
    max = dataset[0].max()
    idx = 1
    while idx <= max:
        frame_data = dataset[dataset[0] == idx]
        if len(frame_data) == 0:
            idx = idx + 1
            continue
            
        save_data = []
        for line in frame_data.values:
            if float(line[6]) > 0.0:
                save_data.append(['Person', line[6], line[2], line[3], line[2] + line[4], line[3] + line[5]])
        
        save_data = pd.DataFrame(save_data)
        save_data.to_csv((save_path % (seq_name[:-4], idx)), sep=' ', index=False, header=False)
        print((save_path % (seq_name[:-4], idx)))
        idx = idx + 1

