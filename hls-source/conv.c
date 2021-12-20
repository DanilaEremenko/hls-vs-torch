#include "conv.h"

void conv(
    data_sc input_img[EXPANDED_HEIGHT][EXPANDED_WIDTH],
    data_sc output_img[TARGET_HEIGHT][TARGET_WIDTH],
    data_sc conv_matrix[CONV_SIZE][CONV_SIZE])
{

LOOP_GLOBAL_HEIGHT:
  for (int g_row = 0; g_row < TARGET_HEIGHT; g_row++)
  {

  LOOP_GLOBAL_WIDTH:
    for (int g_col = 0; g_col < TARGET_WIDTH; g_col++)
    {
      int sum = 0;

    LOOP_LOCAL_HEIGHT:
      for (int l_row = 0; l_row < CONV_SIZE; l_row++)
      {
      LOOP_LOCAL_WIDTH:
        for (int l_col = 0; l_col < CONV_SIZE; l_col++)
        {
          sum += input_img[g_row + l_row][g_col + l_col] * conv_matrix[l_row][l_col];
        }
      }
      output_img[g_row][g_col] = sum;
    }
  }
}
