import matplotlib.pyplot as plt


def save_and_show(fig, save_path, show):
    if type(save_path) == str:
        print(f'saving to {save_path}')
        plt.savefig(save_path, dpi=300)
    if show:
        fig.show()


def draw_image(ax, img_arr, title):
    ax.imshow(img_arr, cmap='gray')
    ax.set_title(title)


def show_image(img_arr, title):
    fig = plt.figure()
    ax = fig.subplots(nrows=1, ncols=1)
    ax.imshow(img_arr, cmap='gray')
    ax.set_title(title)
    fig.show()


def draw_images(imgs, titles, plt_shape, show=True, save_path=None):
    assert len(imgs) == len(titles)
    plt.rc('font', size=14)

    fig, axes = plt.subplots(*plt_shape, figsize=(15, 15))
    fig.tight_layout()

    for i, (img, title) in enumerate(zip(imgs, titles)):
        if len(axes.shape) == 2:
            draw_image(ax=axes[int(i / plt_shape[1]), i % plt_shape[1]], img_arr=img, title=title)
        else:
            draw_image(ax=axes[i], img_arr=img, title=title)

    save_and_show(fig=fig, save_path=save_path, show=show)
