def histogram(seq):
    assert type(seq) in (list, tuple) and len(seq) > 0, "数据类型1不正确"
    assert set(type(v) for v in seq).issubset((int, bool)), "数据类型2不正确"

    # 计算序列中元素绝对值的最大值
    max_abs = max(abs(v) for v in seq)
    # 构造直方图表头，横线长度为最大绝对值加2
    lines = 'ID-|-{}'.format('-' * (max_abs + 2))

    # 构造每一行的直方图
    for idx, v in enumerate(seq):
        if v > 0:
            bar = '*' * v
        elif v < 0:
            bar = '#' * (-v)
        else:
            bar = ''
        # 行号两位宽度，不足补0
        lines += '\n{0:02d}-|-{1}'.format(idx, bar)

    return lines


if __name__ == "__main__":
    # 示例打印
    print(histogram([1, 2, 3, -3, -2]))

