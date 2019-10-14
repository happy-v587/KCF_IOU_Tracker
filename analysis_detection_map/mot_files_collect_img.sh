
ROOT_PATH='/d/vm_disk/ubuntu_16.04/track/data/2DMOT2015/'
NEW_PATH=$ROOT_PATH'collect/'
TRAIN_PATH=$ROOT_PATH'train/'
if [ ! -d $NEW_PATH ]; then
    mkdir $NEW_PATH
fi

floders=$(ls $TRAIN_PATH)
for floder in $floders
do
    imgpath=$TRAIN_PATH$floder"/img1/"    
    files=$(ls $imgpath)
    for file in $files
    do
        new_name=$floder"-"$file
        cp $imgpath$file $NEW_PATH 
        sleep 0.1
        mv $NEW_PATH$file $NEW_PATH$new_name
        echo $NEW_PATH$new_name
    done
done
