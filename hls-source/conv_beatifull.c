#include "conv.h"

void conv(
    data_sc input_img[EXPANDED_HEIGHT][EXPANDED_WIDTH], // входная матрица
    data_sc output_img[TARGET_HEIGHT][TARGET_WIDTH],    // выходная матрица
    data_sc conv_matrix[CONV_SIZE][CONV_SIZE])          // матрица свертки
{
  int sum = 0;
LOOP_GLOBAL_HEIGHT: // цикл по строчкам исходного изображения
  for (int g_row = 0; g_row < TARGET_HEIGHT; g_row++)
  {

  LOOP_GLOBAL_WIDTH: // цикл по столбцам исходного изображения
    for (int g_col = 0; g_col < TARGET_WIDTH; g_col++)
    {
    LOOP_LOCAL_HEIGHT: // цикл по строчкам матрицы свертки
      for (int l_row = 0; l_row < CONV_SIZE; l_row++)
      {
      LOOP_LOCAL_WIDTH: // цикл по столбцам матрицы свертки
        for (int l_col = 0; l_col < CONV_SIZE; l_col++)
        {
          if (l_row == 0 && l_col == 0) // начало свертки для текущего окна изображения
            sum = 0;
          sum += input_img[g_row + l_row][g_col + l_col] * conv_matrix[l_row][l_col]; //умножение текущего окна исходного изображения на матрицу свертки
          if (l_row == (CONV_SIZE - 1) && l_col == (CONV_SIZE - 1)) // сохранение результата свертки для текущего окна изображения
            output_img[g_row][g_col] = sum;
        }
      }
    }
  }
}
