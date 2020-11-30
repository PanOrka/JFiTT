import ply.lex as lex
import ply.yacc as yacc

from mod_oper import (Node, write_list, clear_list, pop,
                      inv_addmod, add_mod, sub_mod, mul_mod,
                      div_mod, pow_mod, MOD_G, true_modulo)

tokens = (
    'VAL', 'ADD', 'SUB', 'MUL', 'DIV',
    'UNARY_MINUS', 'POW', 'L_BRACE', 'R_BRACE', 'END', 'EMPTY'
)

states = (
    ('COMMENT', 'exclusive'),
)

any_symbol = 0


def t_VAL(t):
    r'\d+'
    global any_symbol
    any_symbol = 1
    t.value = int(t.value)
    return t


t_ignore = " \t"


def t_ADD(t):
    r'\+'
    global any_symbol
    any_symbol = 1
    t.type = 'ADD'
    return t


def t_SUB(t):
    r'-'
    global any_symbol
    any_symbol = 1
    t.type = 'SUB'
    return t


def t_MUL(t):
    r'\*'
    global any_symbol
    any_symbol = 1
    t.type = 'MUL'
    return t


def t_DIV(t):
    r'/'
    global any_symbol
    any_symbol = 1
    t.type = 'DIV'
    return t


def t_POW(t):
    r'\^'
    global any_symbol
    any_symbol = 1
    t.type = 'POW'
    return t


def t_L_BRACE(t):
    r'\('
    global any_symbol
    any_symbol = 1
    t.type = 'L_BRACE'
    return t


def t_R_BRACE(t):
    r'\)'
    global any_symbol
    any_symbol = 1
    t.type = 'R_BRACE'
    return t


def t_END(t):
    r'\n+'
    global any_symbol
    if any_symbol:
        any_symbol = 0
        t.type = 'END'
        return t

    t.type = 'EMPTY'
    return t


def t_error(t):
    print(f"Illegal character {t.value[0]!r}")
    t.lexer.skip(1)


# COMMENT STATE
def t_COMMENT(t):
    r'\#'
    t.lexer.begin('COMMENT')


def t_COMMENT_NEWLINE(t):
    r'\n'
    global any_symbol
    t.lexer.begin('INITIAL')
    if any_symbol:
        any_symbol = 0
        t.type = 'END'
        return t


def t_COMMENT_BL(t):
    r'\\\n'


def t_COMMENT_error(t):
    print(f"Illegal character {t.value[0]!r}")
    t.lexer.skip(1)


def t_COMMENT_any(t):
    r'.'


precedence = (
    ('left', 'ADD', 'SUB'),
    ('left', 'MUL', 'DIV'),
    ('left', 'UNARY_MINUS'),
    ('right', 'POW')
)


def p_line_EMPTY(p):
    'line : EMPTY'
    pass


def p_line(p):
    'line : expr END'
    clear_list(True)
    print(f'= \033[0;31m{inv_addmod(p[1])}\033[0m\n')


# expr
def p_expr(p):
    '''expr : expr ADD expr
            | expr SUB expr
            | expr MUL expr
            | expr DIV expr'''
    global MOD_G
    if p[2] == '+':
        p[0] = add_mod(true_modulo(p[1], MOD_G), true_modulo(p[3], MOD_G))
        write_list('+')
    elif p[2] == '-':
        p[0] = sub_mod(true_modulo(p[1], MOD_G), true_modulo(p[3], MOD_G))
        write_list('-')
    elif p[2] == '*':
        p[0] = mul_mod(true_modulo(p[1], MOD_G), true_modulo(p[3], MOD_G))
        write_list('*')
    elif p[2] == '/':
        p[0] = div_mod(true_modulo(p[1], MOD_G), true_modulo(p[3], MOD_G))
        write_list('/')


def p_expr_VAL(p):
    'expr : VAL'
    p[0] = p[1]
    write_list(inv_addmod(p[1]))


def p_expr_UNARY_MINUS(p):
    'expr : SUB _umin %prec UNARY_MINUS'
    p[0] = -p[2]


def p_expr_POW(p):
    'expr : _powl POW _powr'
    p[0] = pow_mod(true_modulo(p[1], MOD_G), true_modulo(p[3], MOD_G))
    write_list('^')


def p_expr_BRACES(p):
    'expr : L_BRACE expr R_BRACE'
    p[0] = p[2]


# _umin
def p_umin_VAL(p):
    '_umin : VAL'
    p[0] = p[1]
    write_list(inv_addmod(-p[1]))


def p_umin_BRACES(p):
    '_umin : L_BRACE expr R_BRACE'
    p[0] = p[2]
    write_list('n')


# _powr
def p_powr_VAL(p):
    '_powr : VAL'
    global MOD_G
    p[0] = p[1]
    write_list(inv_addmod(p[1], mod=MOD_G - 1))


def p_powr_UNARY_MINUS(p):
    '_powr : SUB _powr %prec UNARY_MINUS'
    global MOD_G
    p[0] = -p[2]
    top: int = pop()
    write_list(inv_addmod(-top, mod=MOD_G - 1))


def p_powr_BRACES(p):
    '_powr : L_BRACE _powr R_BRACE'
    p[0] = p[2]


# _powl
def p_powl_VAL(p):
    '_powl : VAL'
    p[0] = p[1]
    write_list(inv_addmod(p[1]))


def p_powl_BRACES(p):
    '_powl : L_BRACE expr R_BRACE'
    p[0] = p[2]


def p_error(p):
    if p is not None:
        print("Syntax error")
    clear_list(False)


if __name__ == "__main__":
    lexer = lex.lex()
    parser = yacc.yacc()

    while True:
        try:
            s = input()
        except EOFError:
            break
        s += '\n'
        print(f"\033[0;31m{s}\033[0m", end="")
        parser.parse(s)
