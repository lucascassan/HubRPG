import numpy as np
import cv2

K =  np.array([[1.10313001e+04, 0.00000000e+00, 1.33481458e+03],
     [0.00000000e+00, 1.10471694e+04, 7.23355988e+02],
      [0.00000000e+00, 0.00000000e+00, 1.00000000e+00]])
dist =  np.array( [-1.21351898e+01, 1.80118816e+03,1.59865700e-01,1.46755659e-01, 5.30182923e+00])


# Carregar uma imagem de teste
test_image = cv2.imread('.\dice.jpg')
# Corrigir a distorção da imagem
undistorted_image = cv2.undistort(test_image, K, dist, None, K)
# Exibir a imagem original e a imagem corrigida lado a lado
combined_image = np.hstack((test_image, undistorted_image))
cv2.imwrite('.\diceun.jpg',undistorted_image)
cv2.imshow('Original vs Undistorted', combined_image)
cv2.waitKey(0)
cv2.destroyAllWindows()