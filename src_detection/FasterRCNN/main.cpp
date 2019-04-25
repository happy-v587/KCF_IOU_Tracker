#define  _CRT_SECURE_NO_WARNINGS

#include <opencv2/dnn.hpp>
#include <opencv2/dnn/all_layers.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <iostream>
#include <string>
#include <fstream>  

using namespace std;
using namespace cv;
using namespace dnn;

#define IS_TRAIN 1

#if IS_TRAIN

//const char* branchName[] = {
//	"ADL-Rundle-6", "ADL-Rundle-8", "ETH-Bahnhof", "ETH-Pedcross2",
//	"ETH-Sunnyday", "KITTI-13", "KITTI-17", "PETS09-S2L1", "TUD-Campus",
//	"TUD-Stadtmitte", "Venice-2"
//};

//const short frameTotal[] = { 525, 654, 1000, 837, 354, 340, 145, 795, 71, 179, 600 };
//const int branchNameLen = 11;

//string root_path = string("D:\\vm_disk\\ubuntu_16.04\\track\\data\\2DMOT2015\\test\\");

const char* branchName[] = {
	"MOT16-02", "MOT16-04", "MOT16-05", "MOT16-09", "MOT16-10", "MOT16-11", "MOT16-13"
};

const short frameTotal[] = { 600, 1050, 837, 525, 654, 900, 750 };
const int branchNameLen = 7;

string root_path = string("F:\\MOT16\\train\\");

#else

const char* branchName[] = {
	"ADL-Rundle-1", "ADL-Rundle-3", "AVG-TownCentre", "ETH-Crossing", 
	"ETH-Jelmoli", "ETH-Linthescher", "KITTI-16", "KITTI-19", "PETS09-S2L2", 
	"TUD-Crossing", "Venice-1"
};
const short frameTotal[] = { 500, 625, 450, 219, 440, 1194, 209, 1059, 436, 201, 450 };
const int branchNameLen = 11;

#endif

const char* classNames[] = {
	"__background__",
	"aeroplane", "bicycle", "bird", "boat",
	"bottle", "bus", "car", "cat", "chair",
	"cow", "diningtable", "dog", "horse",
	"motorbike", "person", "pottedplant",
	"sheep", "sofa", "train", "tvmonitor"
};

static const int kInpWidth = 800;
static const int kInpHeight = 600;

static int oInpWidth;
static int oInpHeigth;

fstream fs;
int frame;

void writeToFile(int frame, float left, float top, float width, float height, float score) {
	fs << frame << ",0," << left << "," << top << "," << width << "," << height << "," << score << ",-1,-1,-1\n";
	fs.flush();
	fs.clear();
}

void frcnn(Net &net, string imagePath, float confThreshold = 0.1) {

	Mat img = imread(imagePath);

	CV_Assert(!img.empty());

	
	oInpWidth = img.cols;
	oInpHeigth = img.rows;
	
	float widthScale = oInpWidth / (kInpWidth * 1.0);
	float heightScale = oInpHeigth / (kInpHeight * 1.0);
	//cout << widthScale << "  " << heightScale << endl;
	resize(img, img, Size(kInpWidth, kInpHeight));
	Mat blob = blobFromImage(img, 1.0, Size(), Scalar(102.9801, 115.9465, 122.7717), false, false);
	Mat imInfo = (Mat_<float>(1, 3) << img.rows, img.cols, 1.6f);

	net.setInput(blob, "data");
	net.setInput(imInfo, "im_info");
	double s_time = getTickCount();
	Mat detections = net.forward();
	cout << "calc use time = " << (getTickCount() - s_time) / getTickFrequency() << endl;
	const float* data = (float*)detections.data;
	for (size_t i = 0; i < detections.total(); i += 7)
	{
		// An every detection is a vector [id, classId, confidence, left, top, right, bottom]
		float confidence = data[i + 2];
		int classId = (int)data[i + 1];
		if (classId == 15 && confidence > confThreshold)
		{

			int left = max(0, min((int)data[i + 3], img.cols - 1));
			int top = max(0, min((int)data[i + 4], img.rows - 1));
			int right = max(0, min((int)data[i + 5], img.cols - 1));
			int bottom = max(0, min((int)data[i + 6], img.rows - 1));

			rectangle(img, Point(left, top), Point(right, bottom), Scalar(0, 255, 0));

			String label = cv::format("%s, %.3f", classNames[classId], confidence);
			int baseLine;
			Size labelSize = cv::getTextSize(label, FONT_HERSHEY_SIMPLEX, 0.5, 1, &baseLine);

			top = max(top, labelSize.height);
			rectangle(img, Point(left, top - labelSize.height),
				Point(left + labelSize.width, top + baseLine),
				Scalar(255, 255, 255), FILLED);
			putText(img, label, Point(left, top), FONT_HERSHEY_SIMPLEX, 0.5, Scalar(0, 0, 0));
			
			/*writeToFile(frame, left * widthScale, top*heightScale, 
				(right - left)*widthScale, (bottom - top)*heightScale, confidence);*/
		}
	}

	//resize(img, img, Size(oInpWidth, oInpHeigth));
	//cvNamedWindow("frame", WINDOW_NORMAL);
	//imshow("frame", img);
	//waitKey(1);
}

void run(Net &net)
{
	while (1) {
		std::cout << ">>input image path\n>>";
		string imagePath;
		std::cin >> imagePath;
		frcnn(net, imagePath);
	}		
}

void 
run(Net &net, size_t i)
{
	string filename = branchName[i];
	int frameLen = frameTotal[i];
	string basePath = root_path + filename + string("\\img1\\");
	fs.open(root_path + filename + string(".txt"), fstream::in | fstream::out | fstream::app);
	
	for (frame = 278; frame <= frameLen; frame++) {
		char str[10];
		sprintf(str, "%06d.jpg", frame);
		cout << " " << branchName[i] << " : " << str << endl;
		string imagePath = basePath + string(str);
		frcnn(net, imagePath);
	}

	fs.close();
}

int 
main(int argc, char** argv)
{
	string basePath = "F:\\mot\\obj_det\\FasterRCNN\\x64\\Debug\\";
	string protoPath = basePath + string("faster_rcnn_vgg16.prototxt");
	string modelPath = basePath + string("VGG16_faster_rcnn_final.caffemodel");

	CV_Assert(!protoPath.empty(), !modelPath.empty());

	Net net = readNetFromCaffe(protoPath, modelPath);

	for (size_t i = 6; i < branchNameLen; i++) {
		cout << "µÚ " << i + 1 << " ¸ö£¬" << branchName[i] << endl;
		run(net, i);
	}
	
	return 0;
}
