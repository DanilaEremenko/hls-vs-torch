import time
from pathlib import Path
import torch
from torch import nn
import numpy as np
import cv2
from plot_part import draw_images


def get_conv_matrix() -> nn.Conv2d:
    k_size = 3
    conv_matrix = nn.Conv2d(
        in_channels=1,
        out_channels=1,
        kernel_size=(k_size, k_size),
        stride=1,
        # dtype=torch.uint8
        # padding=k_size // 2
    )

    with torch.no_grad():
        conv_matrix.weight = nn.Parameter(
            torch.Tensor(
                np.array(
                    [[-1, -2, -1],
                     [0, 0, 0],
                     [1, 2, 1]])
            )[np.newaxis, np.newaxis, ...]
        )
        conv_matrix.bias = nn.Parameter(torch.Tensor([0]))
        conv_matrix = conv_matrix.type(dtype)
        conv_matrix.requires_grad_(False)
    return conv_matrix


def get_batch_from_img(img_path: Path, batch_size: int):
    assert img_path.exists()
    img_src: torch.Tensor = torch.tensor(cv2.cvtColor(cv2.imread(str(img_path)), cv2.COLOR_BGR2GRAY))
    img_src: torch.Tensor = img_src[np.newaxis, np.newaxis, ...]
    img_src: torch.Tensor = img_src.type(dtype)
    img_batch = torch.repeat_interleave(img_src, batch_size, dim=0)
    return img_batch


def write_tensor_to_file(tensor: torch.Tensor, write_path: Path):
    np.savetxt(
        write_path,
        tensor.cpu().detach().numpy().flatten(),
        fmt='%f',
        delimiter=' ',
        newline=' '
    )


# определение вычислительных устройств, для которых будет проведен эксперимент
devices = ["cpu", "cuda"]
# определение типа данных, используемого в эксперименте
dtype = torch.float32

# определение и создание директории, в которую будут сохранены файлы для тестирования собственных реализаций операции свертки
res_dir = Path('test_data')
res_dir.mkdir(parents=True, exist_ok=True)

batch_size = 1

# загрузка исходного изображения из .*jpg файла
img_batch = get_batch_from_img(img_path=Path('input_images/crowd-crosswalk.jpg'), batch_size=batch_size)  

# инициализация ядра свертки
conv_matrix = get_conv_matrix() 
repeat_num = 10
for device in devices:  # замер времени для всех вычислительных устройств
    conv_matrix.to(device) # указание вычислительного устройства для матрицы свертки
    img_batch = img_batch.to(device) # указание вычислительного устройства для матрицы изображения

    time_sum = 0
    for rep_i in range(repeat_num): # цикл измерение временных по нескольким запускам
        start_time = time.time()
        img_res = conv_matrix(img_batch) # операция свертки
        curr_time = time.time() - start_time
        time_sum += curr_time
    print(f"device = {device},\t avg time = {'%.2f' % (time_sum / repeat_num * 1e6)} us") # печать в консоль среднего значения по нескольким запуска в миллисекундах


# запись в файл входного массива
write_tensor_to_file(tensor=img_batch, write_path=Path(f'{res_dir}/input.txt')) 
# запись в файл выходного массива
write_tensor_to_file(tensor=img_res, write_path=Path(f'{res_dir}/res.txt'))
