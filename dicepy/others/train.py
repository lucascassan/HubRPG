import cv2
import numpy as np
import pandas as pd

data = pd.read_csv('datadice.csv')


labels = np.arange(1, 21)
y = data['label'].values
x = data.drop(columns=['label'])

x = x.to_numpy()

knn = cv2.ml.KNearest_create()
knn.train(x,cv2.ml.ROW_SAMPLE,y)