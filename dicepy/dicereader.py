import cv2
import os
import pytesseract
from sys import platform 
import imutils
import math
import numpy as np
import sys
from pytesseract import Output

orig = "a"

def Show(img):
    cv2.imshow("Imagem", img)
    key = cv2.waitKey(0)
    if key == 27:
        cv2.destroyAllWindows()

if 'linux' in platform:
    from picamera2 import Picamera2
    picam2 = Picamera2()
    picam2.preview_configuration.main.size = (1000,1000)
    picam2.preview_configuration.main.format = "RGB888"
    picam2.preview_configuration.align()
    picam2.configure("preview")
    picam2.start()

if 'linux' not in platform:
    pathTesseract = r'C:\Program Files\Tesseract-OCR'
    pytesseract.pytesseract.tesseract_cmd = pathTesseract + r'\tesseract.exe'

def Execute():
    img = ReadImage()
    img, orig = TreatImage(img)
    result = ImageToString(img, orig)
    result = ';'.join(str(v) for v in result)
    print("  Retorno:",result)

def ReadImage():
    print("  Camera::Leitura")

    if 'linux' not in platform:
        return cv2.imread(r'.\dice.jpg')
    else:
        return picam2.capture_array()

def FixAngle(img):
    K = np.array([[1.10313001e+04,0.00000000e+00,1.33481458e+03],
                 [0.00000000e+00,1.10471694e+04,7.23355988e+02],
                 [0.00000000e+00,0.00000000e+00,1.00000000e+00]])
    
    dist = np.array([-1.21351898e+01,1.80118816e+03,1.59865700e-01,1.46755659e-01])
    return cv2.undistort(img, K, dist, None, K)

def Rescale(img, scale_percent):
    width = int(img.shape[1] * scale_percent / 100)
    height = int(img.shape[0] * scale_percent / 100)
    dim = (width, height)
    return cv2.resize(img, dim, interpolation = cv2.INTER_AREA)


def TreatImage(img):
    #tratamento imagem
    img = FixAngle(img)
    img = img [1:1835,252:2200]
    img = Rescale(img,50)
    img_rgb = img
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    img = cv2.GaussianBlur(img, (3, 3), 0) 
    _,img = cv2.threshold(img,160,255,cv2.THRESH_BINARY)

    #img = cv2.bitwise_not(img)
    return img, img_rgb

def ToInt(var):
    try:
        return int(var)
    except ValueError:
        return 0

def ImageToString(img,orig):

    contr, hier = cv2.findContours(img, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)

    result = []
    #selecionando objetos
    for c in contr:
        perimetro = cv2.arcLength(c, True)
        if (perimetro > 500) & (perimetro <2000):
            aprox = cv2.approxPolyDP(c, 0.03 * perimetro, True)
            (x, y, alt, lar ) = cv2.boundingRect(c)

            if len(aprox) >= 5:
                #orig = cv2.rectangle(orig, (x,y), (x+alt, y+lar), (0,255,0), 2)
                #orig = cv2.drawContours(orig, c, -1, (0,0,255), 3)
                subImg = img[y:y+lar, x:x+alt]
                result.append(D20ToString(subImg))
    return result

def ReduzImagem(img, perc):
    h = img.shape[0]
    w = img.shape[1]
    rh = math.trunc(h*perc/100)
    rw = math.trunc(w*perc/100)
    return img[rh:h-rh, rw:w-rw]


def D20ToString_(img):
    Show(img)
    img = ReduzImagem(img, 25)
    
    config = r'-c tessedit_char_whitelist=0123456789. --psm 6'
    result = 0
    for i in range(15):
        var = pytesseract.image_to_string(img, lang='eng', config=config)
        if (var != ""):
            print(var)
            Show(img)

        if (var == '6.'):
            result = 6
            break

        if (ToInt(var) > result) & (ToInt(var) <=20):
            result = ToInt(var)
        img = imutils.rotate(img, angle=25)
        
    return result 


def D20ToString(img):
    Show(img)
    config = r'-c tessedit_char_whitelist=0123456789. --psm 6'
    result = 0
    for i in range(11):
        imgA = ReduzImagem(img, 25)
        var = pytesseract.image_to_string(imgA, lang='eng', config=config)
        
        if (var == '6.'):
            result = 6
            break

        if ((ToInt(var) > result)& (ToInt(var) <=20)):
            result = ToInt(var)

        img = imutils.rotate(img, angle=30)
        
    return result 





def Init():
    if camera.isOpened():
        print("Camera::Iniciada")
    else:
        print("Camera::Não Encontrada- Abortando Execução")
        os.abort()



Execute()

