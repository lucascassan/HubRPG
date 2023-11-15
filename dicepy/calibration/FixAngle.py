import cv2
import numpy as np
import glob

# Parâmetros do tabuleiro de xadrez
chessboard_size = (4, 4)  # Número de cantos internos no tabuleiro (largura x altura)

# Preparar pontos do objeto 3D
objp = np.zeros((np.prod(chessboard_size), 3), dtype=np.float32)
objp[:, :2] = np.indices(chessboard_size).T.reshape(-1, 2)

# Listas para armazenar pontos do objeto 3D e pontos da imagem 2D
object_points = []
image_points = []

list_of_image_files = glob.glob('.\calibration\*.jpg')


# Carregar e processar cada imagem
for image_file in list_of_image_files:
    image = cv2.imread(image_file)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Detectar cantos do tabuleiro de xadrez
    ret, corners = cv2.findChessboardCorners(gray, chessboard_size, None)

    # Se os cantos forem encontrados, adicione os pontos do objeto e da imagem
    if ret:
        object_points.append(objp)
        image_points.append(corners)

        # Desenhar e exibir os cantos
        im2 = cv2.drawChessboardCorners(image, chessboard_size, corners, ret)
        cv2.imshow('img', image)
        cv2.waitKey(500)

cv2.destroyAllWindows()

cv2.imwrite('tab.jpg', im2)

# Calibrar a câmera
ret, K, dist, rvecs, tvecs = cv2.calibrateCamera(
    object_points, image_points, gray.shape[::-1], None, None
)

print("Matriz de calibração K:\n", K)
print("Distorção:", dist.ravel())

print(type(K))

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