class Node:
    def __init__(self, next, prev, val):
        self.next = next
        self.prev = prev
        self.val = val


mem: Node = None
tail: Node = None


def write_list(val) -> int:
    global mem, tail

    new_node = Node(None, tail, val)

    if mem is not None:
        tail.next = new_node
    else:
        mem = new_node

    tail = new_node


def pop():
    global mem, tail

    ret_val: int = 0
    if mem is not None:
        ret_val = tail.val

        tail = tail.prev
        if tail is not None:
            tail.next = None
        else:
            mem = None

    return ret_val


def clear_list(print_out: bool):
    global mem, tail

    while mem is not None:
        if print_out:
            print(f"{mem.val} ", end="")

        mem = mem.next
    tail = None
    if print_out:
        print("")


MOD_G: int = 1234577


def inv_mulmod(a: int) -> int:
    a = a if a >= 0 else MOD_G + a

    x, y, u, v = 0, 1, 1, 0
    b = MOD_G
    while a != 0:
        q, r = b // a, true_modulo(b, a)
        m, n = x - u * q, y - v * q
        b = a
        a = r
        x = u
        y = v
        u = m
        v = n

    return x // b


def inv_addmod(a: int, mod=MOD_G) -> int:
    return true_modulo(a, mod) if a >= 0 else mod + true_modulo(a, mod)


def add_mod(a: int, b: int) -> int:
    return true_modulo(a + b, MOD_G)


def sub_mod(a: int, b: int) -> int:
    return true_modulo(a - b, MOD_G)


def mul_mod(a: int, b: int) -> int:
    acc: int = 0
    b = b if b >= 0 else MOD_G + b

    for _ in range(b):
        acc = add_mod(acc, a)

    return acc


def div_mod(a: int, b: int) -> int:
    return mul_mod(a, inv_mulmod(b))


def pow_mod(a: int, b: int) -> int:
    inv: bool = b < 0
    b = -b if inv else b

    acc: int = 1
    for _ in range(b):
        acc = mul_mod(acc, a)

    return inv_mulmod(acc) if inv else acc


def true_modulo(a: int, mod: int) -> int:
    return a - int(a/mod)*mod
