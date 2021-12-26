#include "conv.h"

void conv(
    data_sc input_img[EXPANDED_HEIGHT][EXPANDED_WIDTH], // входная матрица
    data_sc output_img[TARGET_HEIGHT][TARGET_WIDTH],    // выходная матрица
    data_sc conv_matrix[CONV_SIZE][CONV_SIZE])          // матрица свертки
{

L1: // цикл по строчкам исходного изображения
  for (int g_row = 0; g_row < TARGET_HEIGHT; g_row++)
  {

  L2: // цикл по столбцам исходного изображения
    for (int g_col = 0; g_col < TARGET_WIDTH; g_col++)
    {
      int sum = 0;

    L3: // цикл по строчкам матрицы свертки
      for (int l_row = 0; l_row < CONV_SIZE; l_row++)
      {
      L4: // цикл по столбцам матрицы свертки
        for (int l_col = 0; l_col < CONV_SIZE; l_col++)
        {
          sum += input_img[g_row + l_row][g_col + l_col] * conv_matrix[l_row][l_col]; //умножение текущего окна исходного изображения на матрицу свертки
        }
      }
      output_img[g_row][g_col] = sum;
    }
  }
}
